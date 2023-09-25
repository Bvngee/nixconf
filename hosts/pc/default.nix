{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pc";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable = true; 

  services.xserver.videoDriver = [ "nvidia" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
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

