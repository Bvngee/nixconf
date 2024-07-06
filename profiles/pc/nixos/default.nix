# Custom configuration for my pc
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  system.stateVersion = "23.05";

  boot.binfmt.emulatedSystems = [
    "x86_64-windows"
    "aarch64-linux"
  ];
}
