{ lib, pkgs, isMobile, ... }: {

  # General power-related features (suspent-to-ram, general powersaving)
  powerManagement.enable = true;

  # DBus service that provides power management support for applications
  services.upower.enable = true;

  # Linux power management interface, specifically used for hardware integrations
  services.acpid.enable = isMobile;

  services.auto-cpufreq = {
    enable = isMobile;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
      charger = {
        governor = "powersave";
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
      unplugged = pkgs.writeShellScript "unplugged" ''
        notify-send "Disconnected from AC power!"
      '';

      plugged = pkgs.writeShellScript "plugged" ''
        notify-send "Connected to AC power!"
      '';
    in
    lib.mkIf (isMobile)
      ''
        # start/stop services on power (un)plug
        SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${plugged}"
        SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${unplugged}"
      '';
}
