{ pkgs, ... }: {
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    GDK_BACKEND = "wayland,x11";
    SLD_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    XDG_SESSION_TYPE = "wayland";

    NIXOS_OZONE_WL = "1";

    LIBSEAT_BACKEND = "logind";
  };

  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true; # TODO: improve this section
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [
        "gnome-keyring"
      ]; #not sure this is necessary
    };
  };
}
