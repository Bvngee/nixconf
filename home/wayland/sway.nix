{ ... }: {

  wayland.windowManager.sway = {
    # Enable configuration of Sway via HM.
    enable = true;
    # Only use the NixOS module's sway package to avoid duplication.
    # Note: this breaks config auto-reloading
    package = null;

    systemd.enable = true;
    systemd.xdgAutostart = true;
    systemd.variables = [ "--all" ];
    systemd.dbusImplementation = "broker";
  };

}
