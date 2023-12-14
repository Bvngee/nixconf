{ config, pkgs, ... }: {
  boot = {
    # Kernel version and package set.
    # Uncomment or change if problems occur.
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # Alias to pkgs.linuxKernel.packages.linux_xanmod_latest

    # Any extra kernel modules go here
    #extraModulePackages = with config.boot.kernelPackages; [];
    #kernelModules = [];
  };
}
