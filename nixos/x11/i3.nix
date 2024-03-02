{ config, lib, pkgs, ... }:
let
  cfg = config.services.xserver.windowManager.i3;
in
{
  services.xserver.windowManager.i3 = {
    # add stuff manually
    enable = false;

    # NOTE: none of this is configured at all
    extraPackages = with pkgs; [
      dmenu #application launcher most people use
      i3status # gives you the default i3 status bar
      i3lock #default i3 screen locker
    ];
  };

  environment.systemPackages = [
    cfg.package
  ] ++ cfg.extraPackages;

  # Add i3 startup command manually to display manager session list
  # (ass opposed to window manager list)
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "startx-i3";
      start = ''
        ${cfg.extraSessionCommands}

        ${lib.optionalString cfg.updateSessionEnvironment ''
          systemctl --user import-environment PATH DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_RUNTIME_DIR XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS || true
          dbus-update-activation-environment --systemd --all || true
        ''}

        startx ${cfg.package}/bin/i3 -- vt1 &
        waitPID=$!
      '';
    }
  ];
}
