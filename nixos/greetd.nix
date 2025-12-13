{ config, pkgs, ... }:
let
  sessionData = config.services.displayManager.sessionData.desktops;
  waylandSessions = "${sessionData}/share/wayland-sessions";
  xSessions = "${sessionData}/share/xsessions";
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true; # Otherwise boot logs will be spammed over tuigreet on the VT
    settings = {
      default_session = {
        # note: default --xsession-wrapper is "startx /usr/bin/env"
        # note: see ./wayland/environment.nix for wayland-session-wrapper.sh
        command = ''${pkgs.tuigreet}/bin/tuigreet \
          --sessions ${waylandSessions} \
          --session-wrapper /etc/wayland-session-wrapper.sh \
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
      #   user = config.host.user;
      # };
    };
  };
}
