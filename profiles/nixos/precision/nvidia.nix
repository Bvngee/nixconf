{ config, ... }: {
  # For a more thorough nvidia config, see my pc's nvidia settings.
  # Partially stolen from nixos-hardware
  hardware.nvidia = {
    nvidiaSettings = false;
    modesetting.enable = true;
    powerManagement.enable = false; # not new enough to support this
    open = false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
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
  boot.blacklistedKernelModules = [ "nouveau" ];
  #environment.variables.VDPAU_DRIVER = "nvidia";

  services.xserver.videoDrivers = [ "nvidia" ];
}
