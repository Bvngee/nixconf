# Custom configuration for my pc
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  system.stateVersion = "23.05";
}
