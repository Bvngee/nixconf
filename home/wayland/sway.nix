{ pkgs, ... }: {

  wayland.windowManager.sway = {
    # Enable configuration of Sway via HM.
    enable = true;
    # Only use the NixOS module's sway package to avoid duplication.
    # Note: this breaks config auto-reloading
    package = null;

    systemd.enable = true;
    # systemd.enableXdgAutostart = true; # TODO(25.05)
    systemd.variables = [ "--all" ];

    # TODO(25.05)
    # # defaults include a few more I don't need
    # extraPackages = with pkgs; [ swayidle swaylock wmenu ];
  };

}
