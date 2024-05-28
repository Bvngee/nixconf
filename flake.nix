{
  description = "BvngeeCord's NixOS system and home configurations";

  outputs = { nixpkgs, ... }@inputs: {

    nixosConfigurations = import ./profiles/nixos { inherit nixpkgs inputs; };

    homeConfigurations = import ./profiles/home { inherit nixpkgs inputs; };

  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # v0.36.0 does not include the following commit, and will be patched instead
    # https://github.com/hyprwm/Hyprland/commit/8e2a62e53bf51e8b4ae719d0e46797b0a26eeb22
    hyprland.url = "github:hyprwm/Hyprland/v0.36.0";

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.36.0";
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
