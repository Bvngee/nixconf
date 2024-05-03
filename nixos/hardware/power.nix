{ lib, pkgs, isMobile, ... }: {
  services.tlp = lib.mkIf (isMobile) {
    enable = true;
    setings = {
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
    };
  };

  udev.extraRules =
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
