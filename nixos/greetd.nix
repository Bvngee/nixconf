{ config, pkgs, user, ... }: let
  sessionData = config.services.displayManager.sessionData.desktops;
  waylandSessions = "${sessionData}/share/wayland-sessions";
  xSessions = "${sessionData}/share/xsessions";

  # TODO: Remove if this doesn't fix gnome bugginess (KDE shouldn't need it, dont need redundancy)
  # https://github.com/KDE/plasma-workspace/blob/6da08298e03eba4d8f94d53c9b0eb999b70f6cad/startkde/plasma-dbus-run-session-if-needed#L2
  waylandWrapper = pkgs.writeShellScript "wayland-session-wrapper" ''
    drs=
    if [ -z "$${DBUS_SESSION_BUS_ADDRESS}" ]
    then
        drs=dbus-run-session
    fi
    XDG_SESSION_TYPE=wayland exec $${drs} "$@"
  '';
  # xsession-wrapper below is just the default afaik, can also be removed
in {
  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        # --session-wrapper ${waylandWrapper.outPath} \
        # --xsession-wrapper "startx /usr/bin/env" \
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
      #   user = user;
      # };
    };
  };
}
