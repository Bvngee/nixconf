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
    package = config.boot.kernelPackages.nvidiaPackages.production; # production => 535
  };

  # not sure if this is necessary, stolen from sioodmy's dotfiles
  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  # no idea if these are necessary. note: nvidia-vaapi-driver is added automatically but kept here for explicitness sake
  hardware.opengl.extraPackages = with pkgs; [ libva nvidia-vaapi-driver ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva nvidia-vaapi-driver ];

  # necessary for both X and Wayland based apps
  services.xserver.videoDrivers = [ "nvidia" ];

  # only necessary on SOME nvidia systems
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
}
