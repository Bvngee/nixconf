# Custom configuration for my pc
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./sensors.nix
  ];

  system.stateVersion = "23.05";
}
