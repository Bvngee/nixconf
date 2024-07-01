{ config, pkgsUnstable, ... }: {
  boot = {
    # Kernel version and package set.
    # Has to be from pkgsUnstable so that the nvidiaPackages sub-attribute has the latest driver versions.
    kernelPackages = pkgsUnstable.linuxPackages_xanmod_stable; # Alias to pkgs.linuxKernel.packages.linux_xanmod_stable

    # Any extra kernel modules go here
    #extraModulePackages = with config.boot.kernelPackages; [];
    #kernelModules = [];
  };
}
