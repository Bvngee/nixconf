{ inputs, pkgs, ... }: {

  imports = [ inputs.hyprland.nixosModules.default ];

  environment.sessionVariables = {
    _JAVA_AWT_WM_NONPARENTING = "1";

    QT_QPA_PLATFORM = "wayland";
    SLD_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";

    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";

    LIBSEAT_BACKEND = "logind";
  };

  # does this need to be here?
  # TODO: remove, and refactor to /wayland/vars.nix + /wayland/hyprland.nix
  programs.hyprland = {
    enable = true;
  };

  xdg.portal.xdgOpenUsePortal = true; # TODO: improve this section
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = [ "gtk" ];
}
