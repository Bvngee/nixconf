# Custom configuration for Dell Latitude laptop
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.opengl.extraPackages = [ pkgs.intel-media-driver ];
  hardware.opengl.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  system.stateVersion = "23.05";
}
