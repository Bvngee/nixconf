{ config, pkgs, ... }: let
  sessionData = config.services.displayManager.sessionData.desktops;
  waylandSessions = "${sessionData}/share/wayland-sessions";
  xSessions = "${sessionData}/share/xsessions";
in {
  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        # default --xsession-wrapper is "startx /usr/bin/env"
        command = ''${pkgs.greetd.tuigreet}/bin/tuigreet \
          --sessions ${waylandSessions} \
          --xsessions ${xSessions} \
          --remember \
          --remember-session \
          --asterisks \
          --time \
          --time-format "%H:%M, %m/%d/%Y" \
          --window-padding 2
        '';
        user = "greeter";
      };
      # TODO: once I've settled on a more permanent DE/env, make it autologin by setting this
      # initial_session = {
      #   command = ;
      #   user = config.profile.user;
      # };
    };
  };
}
