# Custom configuration for Dell Latitude laptop
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  system.stateVersion = "23.05";
}
