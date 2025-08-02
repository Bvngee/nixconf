{ ... }: {
  # Custom module definitions.
  # common/: Imported in both NixOS and Home Manager configurations
  # nixos/: Imported only in NixOS configurations
  # home/: Imported only in Home Manager configurations

  # See module files for explanations.
  imports = [
    ./common/host.nix

    ./common/nixpkgs-config.nix

    ./common/nixpkgs-unstable.nix
  ];
}
