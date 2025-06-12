{ config, pkgs, ... }: {

  # Kernel module containing HMS Ixxat socketCAN drivers. Downloaded from
  # https://www.hms-networks.com/support/general-downloads. The tarball
  # contained multiple drivers; This is only `ix_usb_can_2.0.xxx-REL.tgz`,
  # for "all USB-to-CAN V2 and USB-to-CAN-FD family adapters".
  boot.extraModulePackages = [
    (pkgs.callPackage ../../pkgs/ix_usb_can {
      kernel = config.boot.kernelPackages.kernel;
    })
  ];
  boot.kernelModules = [ "ix_usb_can" ];

  environment.systemPackages = with pkgs; [
    # CLI tools for interfacing with socketCAN interfaces
    can-utils

    # GUI tool for interfacing with socketCAN interfaces
    savvycan
  ];
}
