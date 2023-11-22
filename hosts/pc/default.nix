{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "pc";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      # no idea if these are necessary. note: nvidia-vaapi-driver is added automatically
      extraPackages = with pkgs; [ libva ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    nvidia = {
      # until https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472 is resolved?
      open = false;
      # suspend/resume; also adds NVreg_PreserveVideoMemoryAllocations=1 kernel param
      powerManagement.enable = true; 

      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # true is not recommended.
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

