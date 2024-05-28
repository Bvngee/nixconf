{ config, pkgs, ... }: {
  # Change depending on hostname later if necessary

  hardware.nvidia = {
    # until https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472 is resolved?
    open = false;

    # suspend/resume; also adds NVreg_PreserveVideoMemoryAllocations=1 kernel param
    powerManagement.enable = true;

    modesetting.enable = true; # also adds nvidia-drm.modeset=1 kernel param

    nvidiaSettings = false; # basically useless software

    # unbearable XWayland flickering on stable/latest due to no explicit sync support
    # https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/967
    #package = config.boot.kernelPackages.nvidiaPackages.production; # production => 535

    # beta 555 drivers with explicit sync support!
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.42.02";
      sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      sha256_aarch64 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
      openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
    };
  };

  # only works for 545+ I think
  # https://wiki.archlinux.org/title/Talk:NVIDIA#Framebuffer_consoles_experimental_support
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  # not sure if this is necessary, stolen from sioodmy's dotfiles
  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  # no idea if these are necessary. note: nvidia-vaapi-driver is added automatically but kept here for explicitness sake
  hardware.opengl.extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];

  # necessary for both X and Wayland based apps
  services.xserver.videoDrivers = [ "nvidia" ];

  # only necessary on SOME nvidia systems
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
}
