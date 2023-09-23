{
  description = "BvngeeCord's NixOS system and home configurations";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # todo: split into different hosts (pc, laptop, default?) and users (jack, default?)?
      nixosConfigurations = {
        "pc" = nixpkgs.lib.nixosSystem {

          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/pc
            ./hosts/shared
             
            ./modules/desktop
            ./modules/greetd.nix
          ];
        };
      };
      homeConfigurations = {
        "jack@pc" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/shared.nix
            ./home/kitty.nix
            ./home/kdeconnect.nix
            ./home/git.nix
            ./home/xdg.nix
            ./home/programs.nix
            ./home/wayland
            ./home/shell
            inputs.hyprland.homeManagerModules.default
          ];
        };
      };
    };
}
