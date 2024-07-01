{ config, ... }: {
  # Nvidia config for pc's GTX 1650S

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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # only works for 545+ I think
  # https://wiki.archlinux.org/title/Talk:NVIDIA#Framebuffer_consoles_experimental_support
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
  
  # Make sure we're not uing nouveau
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Note: nvidia-vaapi-driver is added automatically with "nvidia" added to videoDrivers
  hardware.opengl.extraPackages = [ ]; # I don't think vaapiVdpau is necessary? Still not sure
  hardware.opengl.extraPackages32 = [ ];

  # necessary for both X and Wayland based apps
  services.xserver.videoDrivers = [ "nvidia" ];
}
