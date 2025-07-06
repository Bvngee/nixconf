{
  description = "BvngeeCord's NixOS system and home configurations";

  outputs = { nixpkgs, ... }@inputs: {

    nixosConfigurations = import ./profiles/nixosConfigs.nix { inherit nixpkgs inputs; };

    homeConfigurations = import ./profiles/homeConfigs.nix { inherit nixpkgs inputs; };

  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # sometimes I want to update nnixpkgs-unstable without recompiling linux_xanmod and
    # nvidia drivers. When I do feel like it, I can fast-forward this
    nixpkgs-kernel-packages.url = "github:nixos/nixpkgs/nixos-24.11";

    # because I have no will to report stupid bugs, and this seems to fix my multi-monitor bar
    nixpkgs-ironbar.url = "github:nixos/nixpkgs/fc55cdb8340a3258a1ad6f3eb8df52dac36c3e70";

    # nix-index, but with a prebuilt database (and convenient hm/nixos modules)
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for the nixos module's xremap systemd service only. Package is used from nixpkgs
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16.url = "github:SenchoPens/base16.nix";
  };
}
