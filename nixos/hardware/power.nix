{ lib, pkgs, isMobile, ... }: {

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
        governor = "balanced";
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

  # TODO: none of this is working
  services.udev.extraRules =
    let
      unplugged = pkgs.writeShellScript "unplugged" ''
        ${lib.getExe pkgs.libnotify} "Disconnected from AC power!"
      '';

      plugged = pkgs.writeShellScript "plugged" ''
        ${lib.getExe pkgs.libnotify} "Connected to AC power!"
      '';
      lowBattery = pkgs.writeShellScript "lowBattery" ''
        ${lib.getExe pkgs.libnotify} -u critical "Battery critically low!"
      '';
    in
    lib.mkIf (isMobile)
      ''
        # notify-send critical battery/charge information
        SUBSYSTEM=="power_supply", ATTR{online}=="1", ENV{DBUS_SESSION_BUS_ADDRESS}="unix:path=/run/user/$UID/bus", RUN+="${pkgs.su}/bin/su jack -c ${plugged}"
        SUBSYSTEM=="power_supply", ATTR{online}=="0", ENV{DBUS_SESSION_BUS_ADDRESS}="unix:path=/run/user/$UID/bus", RUN+="${pkgs.su}/bin/su jack -c ${unplugged}"
        SUBSYSTEM=="power_supply", ATTR{status}=="discharging", ATTR{capacity}=="[0-5]", ENV{DBUS_SESSION_BUS_ADDRESS}="unix:path=/run/user/$UID/bus", RUN+="${pkgs.su}/bin/su jack -c ${lowBattery}"
      '';
}
