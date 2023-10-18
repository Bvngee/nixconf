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
             
            ./nixos/desktop.nix
            ./nixos/greetd.nix
            ./nixos/wayland.nix
            ./nixos/kde.nix
          ];
        };
      };
      homeConfigurations = {
        "jack@pc" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/home.nix
            ./home/kitty.nix
            #./home/kdeconnect.nix
            ./home/git.nix
            ./home/xdg.nix
            ./home/theme.nix
            ./home/programs.nix
            ./home/wayland
            ./home/shell
            ./home/nvim
            inputs.hyprland.homeManagerModules.default
          ];
        };
        "jack@wsl" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/home.nix
            ./home/git.nix
            ./home/xdg.nix
            ./home/programs.nix
            ./home/shell
            ./home/nvim
            {programs.home-manager.enable = nixpkgs.lib.mkForce true;}
          ];
        };
      };
    };
}
