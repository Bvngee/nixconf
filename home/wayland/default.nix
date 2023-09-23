{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./swayidle.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    swww
    wl-clipboard
    wlr-randr
  ];

  home.sessionVariables = {
    _JAVA_AWT_WM_NONPARENTING = "1";

    QT_QPA_PLATFORM = "wayland";
    SLD_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";

    NIXOS_OZONE_WL = "1";
  };
}
