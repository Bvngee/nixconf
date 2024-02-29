{
  description = "BvngeeCord's NixOS system and home configurations";

  outputs = { nixpkgs, ... }@inputs: {

    nixosConfigurations = import ./profiles/nixos { inherit nixpkgs inputs; };

    homeConfigurations = import ./profiles/home { inherit nixpkgs inputs; };

  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nix-gaming.url = "github:fufexan/nix-gaming";

    base16.url = "github:SenchoPens/base16.nix";

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Requires git SSH access to the repo as of now (still private)
    #ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty?ref=main&rev=09c765f42a0c972b0cd5367a5195a600a261e400";
    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
  };

}
