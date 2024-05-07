{ config, pkgs, ... }: {
  boot = {
    # Kernel version and package set.
    # (not using latest or stable here bc ddcci-driver-linux's 6.8-compat code isn't in nixpkgs yet)
    kernelPackages = pkgs.linuxPackages_xanmod; # Alias to pkgs.linuxKernel.packages.linux_xanmod

    # Any extra kernel modules go here
    #extraModulePackages = with config.boot.kernelPackages; [];
    #kernelModules = [];
  };
}
