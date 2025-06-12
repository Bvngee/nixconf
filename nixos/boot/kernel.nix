{ inputs, pkgs, ... }: {
  boot = {
    # Kernel version and package set.
    # Note(nixos-24.05): has to be from pkgsUnstable so that the nvidiaPackages
    # sub-attribute has the latest driver versions.
    kernelPackages =
      let
        # I use a separate, dedicated nixpkgs input for this because I _hate_ recompiling
        # the kernel and nvidia drivers every time I update pkgsUnstable.
        pkgsKernelPackages = import inputs.nixpkgs-kernel-packages {
          inherit (pkgs) system;
          config.allowUnfree = true; # proprietary nvidia drivers
        };
      in
      pkgsKernelPackages.linuxPackages_xanmod; # alias to pkgs.linuxKernel.packages.linux_xanmod

    # Any extra kernel modules go here
    extraModulePackages = [ ]; #with config.boot.kernelPackages; 
    kernelModules = [ "ix_usb_can" ];
  };
}
