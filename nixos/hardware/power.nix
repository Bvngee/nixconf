{ config, lib, pkgs, ... }:
let
  inherit (config.host) isMobile mainUser;
in
{

  # General power-related features (suspent-to-ram, general powersaving)
  powerManagement.enable = true;

  # DBus service that provides power management support for applications
  services.upower.enable = true;

  # Linux power management interface, specifically used for hardware integrations
  services.acpid.enable = true;

  services.auto-cpufreq = {
    enable = isMobile;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Provides a DBus interface for users to be able to switch between power saving modes
  services.power-profiles-daemon.enable = false; # prefer auto-cpufreq

  # services.tlp = lib.mkIf (isMobile) { # prefer auto-cpufreq
  #   enable = true;
  #   setings = {
  #     DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
  #   };
  # };

  # Throttles CPU freq if temps get too high - temperature management daemon
  services.thermald.enable = isMobile;

  environment.systemPackages = with pkgs; [
    powertop
  ];

  services.udev.extraRules =
    let
      notifyUser = pkgs.writeCBin "notifyUser" ''
        #include <pwd.h>
        #include <stdlib.h>
        #include <stdio.h>
        #include <unistd.h>
        
        #define MAX_ARGC 32
        int main(int argc, char *argv[]) {
            if (argc < 2 || argc > MAX_ARGC) exit(1);
            struct passwd *pw = getpwnam("${mainUser}");
            char env_var[64] = {0};
            snprintf(env_var, 64, "XDG_RUNTIME_DIR=/run/user/%d", pw ? pw->pw_uid : 1000);
            char *const notify_envp[] = {env_var, NULL};
            char *notify_argv[MAX_ARGC] = { "notify-send" };
            for (int i=1; i<argc; i++) notify_argv[i] = argv[i];
            notify_argv[argc] = NULL;
            execve("${lib.getExe pkgs.libnotify}", notify_argv, notify_envp);
        }
      '';
      udevNotify = urgency: notifyArgsStr: "${pkgs.su}/bin/su ${mainUser} -s ${notifyUser}/bin/notifyUser -- -u ${urgency} '${notifyArgsStr}'";

      notifyPlugged = udevNotify "normal" "Connected to AC power!";
      notifyUnplugged = udevNotify "normal" "Disconnected from AC power!";
      notifyBatteryLow = udevNotify "critical" "Battery low! (10%%)";
      notifyBatteryCritical = udevNotify "critical" "Battery critically low! (5%%)";
    in
    lib.mkIf (config.host.isMobile)
      ''
        # Notify the user of critical battery/charge information.
        # note: KERNEL=="AC" prevents duplicate messages, ACTION=="change" prevents misfires (eg. on wake-from-suspend)
        SUBSYSTEM=="power_supply", KERNEL=="AC", ACTION=="change", ATTR{online}=="1", RUN+="${notifyPlugged}"
        SUBSYSTEM=="power_supply", KERNEL=="AC", ACTION=="change", ATTR{online}=="0", RUN+="${notifyUnplugged}"
        SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[5-10]", RUN+="${notifyBatteryLow}"
        SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-5]", RUN+="${notifyBatteryCritical}"
      '';
}
