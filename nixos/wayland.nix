{ inputs, ... }: {

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
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };

}
