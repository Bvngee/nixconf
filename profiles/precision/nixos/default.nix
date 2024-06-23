# Custom configuration for Dell Precision laptop
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  # Stolen from nixos-hardware
  boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" "i915.modeset=1" ];

  hardware.opengl.extraPackages = [ pkgs.intel-media-driver ];
  hardware.opengl.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  system.stateVersion = "24.05";
}
