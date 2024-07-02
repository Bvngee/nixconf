{ pkgs, ... }: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [ libva ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
  };

  environment.systemPackages = with pkgs; [
    # not sure if these are necessary at all; stolen from the nvidia section of sioodmy's dotfiles
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-tools

    # probably useful for debugging
    mesa-demos
    glxinfo
    vdpauinfo
    libva-utils
  ];

}
