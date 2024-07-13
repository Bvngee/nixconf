{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0f2b7eab-8d03-428a-a591-99e79968591d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FFC5-C695";
      fsType = "vfat";
    };

  fileSystems."/mnt/SecondaryDrive" =
    { device = "/dev/disk/by-uuid/70927F05927ECF5A";
      fsType = "ntfs3";
      options = [ "rw" "uid=1000" ];
    };

  fileSystems."/mnt/windows" =
    { device = "/dev/disk/by-uuid/6426DFAA26DF7C0C";
      fsType = "ntfs3";
      options = [ "rw" "uid=1000" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8c8e62d4-999c-4b9d-90b1-f4f7ec7f9c41"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
