{ config, lib, ... }: {
  # Stolen directly from nixos-hardware. For a more thorough
  # nvidia config better suited for modern gpus, see my pc's nvidia settings
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    nvidiaSettings = lib.mkDefault true;
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
  environment.variables.VDPAU_DRIVER = "nvidia";

  services.xserver.videoDrivers = [ "nvidia" ];
}
