{ inputs, pkgs, ... }: {

  imports = [ inputs.hyprland.nixosModules.default ];

  environment.sessionVariables = {
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    GDK_BACKEND = "wayland,x11";
    SLD_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    XDG_SESSION_TYPE = "wayland";

    NIXOS_OZONE_WL = "1";

    LIBSEAT_BACKEND = "logind";
  };

  # does this need to be here?
  # TODO: remove, and refactor to /wayland/vars.nix + /wayland/hyprland.nix
  programs.hyprland = {
    enable = true;
  };

  xdg = {
    portal.xdgOpenUsePortal = true; # TODO: improve this section
    portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    portal.config.common.default = [ "gtk" ];
    portal.config.hyprland.default = [ "hyprland" "gtk" ];
  };
}
