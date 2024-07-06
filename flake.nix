{
  description = "BvngeeCord's NixOS system and home configurations";

  outputs = { nixpkgs, ... }@inputs: {

    nixosConfigurations = import ./profiles/nixosConfigs.nix { inherit nixpkgs inputs; };

    homeConfigurations = import ./profiles/homeConfigs.nix { inherit nixpkgs inputs; };

    packages =
      let
        supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
        forAllSystems = fn:
          nixpkgs.lib.genAttrs supportedSystems (system: fn nixpkgs.legacyPackages.${system});
      in
      forAllSystems (pkgs: rec {
        github-readme-stats = pkgs.callPackage ./pkgs/github-readme-stats { };
        github-readme-stats-docker = pkgs.callPackage ./pkgs/github-readme-stats/docker.nix {
          inherit github-readme-stats;
        };
      });
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # because I have no will to report stupid bugs, and this seems to fix my multi-monitor bar
    nixpkgs-ironbar.url = "github:nixos/nixpkgs?ref=fc55cdb8340a3258a1ad6f3eb8df52dac36c3e70";

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

    # not in nixpkgs yet
    woomer.url = "github:coffeeispower/woomer";

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    base16.url = "github:SenchoPens/base16.nix";

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Temporarily disabled, as git auth via ssh is ANNOYING
    # # Requires git SSH access to the repo as of now (still private)
    # #ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty?ref=main&rev=09c765f42a0c972b0cd5367a5195a600a261e400";
    # ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
  };

}
