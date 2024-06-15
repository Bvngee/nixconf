# Custom configuration for Dell Precision laptop
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  # Stolen from nixos-hardware
  boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" "i915.modeset=1" ];

  system.stateVersion = "24.05";
}
