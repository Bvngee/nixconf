{ config, lib, pkgs, ... }: let
  sessionData = config.services.xserver.displayManager.sessionData.desktops;
  sessions = lib.concatStringsSep ":" [
    "${sessionData}/share/wayland-sessions"
    "${sessionData}/share/xsessions"
  ];
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''${pkgs.greetd.tuigreet}/bin/tuigreet \
          --sessions ${sessions} \
          --remember \
          --remember-user-session \
          --asterisks \
          --time \
          --time-format "%H:%M, %m/%d/%Y" \
          --window-padding 2
        '';
        user = "greeter";
      };
    };
  };
}
