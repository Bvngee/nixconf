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

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nix-gaming.url = "github:fufexan/nix-gaming";

    base16.url = "github:SenchoPens/base16.nix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      conf = {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = pkgs: true;
      };
      pkgs = import nixpkgs conf;
      pkgsUnstable = import inputs.nixpkgs-unstable conf;
    in {
      nixosConfigurations = {
        "pc" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            ./hosts/pc
            ./hosts/shared

            ./nixos/hardware/audio.nix
            ./nixos/hardware/openrgb.nix
            ./nixos/hardware/printing.nix
            ./nixos/programs/gaming.nix
            ./nixos/programs/thunar.nix
            ./nixos/programs/xremap.nix
            ./nixos/programs/kdeconnect.nix
            ./nixos/greetd.nix
            ./nixos/wayland.nix #TODO: figure out where these three go
            ./nixos/kde.nix
            { services.xremap.deviceName = "GMMK"; }
          ];
        };
        "latitude" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            ./hosts/latitude
            ./hosts/shared

            ./nixos/hardware/audio.nix
            ./nixos/hardware/printing.nix
            ./nixos/programs/gaming.nix
            ./nixos/programs/thunar.nix
            ./nixos/programs/xremap.nix
            ./nixos/programs/kdeconnect.nix
            ./nixos/greetd.nix
            ./nixos/wayland.nix #TODO: figure out where these three go
            ./nixos/kde.nix
          ];
        };
      };
      homeConfigurations = {
        "jack@pc" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            ./home/home.nix
            ./home/kitty.nix
            ./home/spicetify.nix
            #./home/kdeconnect.nix
            ./home/git.nix
            ./home/xdg.nix
            ./home/theme.nix
            ./home/base16.nix
            ./home/programs/coding.nix
            ./home/programs/cli.nix
            ./home/programs/gui.nix
            ./home/wayland
            ./home/shell
            ./home/nvim
            {wayland.windowManager.hyprland.enableNvidiaPatches = true;}
          ];
        };
        "jack@latitude" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            ./home/home.nix
            ./home/kitty.nix
            ./home/spicetify.nix
            #./home/kdeconnect.nix
            ./home/git.nix
            ./home/xdg.nix
            ./home/theme.nix
            ./home/base16.nix
            ./home/programs/coding.nix
            ./home/programs/cli.nix
            ./home/programs/gui.nix
            ./home/wayland
            ./home/shell
            ./home/nvim
          ];
        };
        "jack@wsl" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            ./home/home.nix
            ./home/git.nix
            ./home/xdg.nix
            ./home/programs/coding.nix
            ./home/programs/cli.nix
            ./home/shell
            ./home/nvim
            { programs.home-manager.enable = nixpkgs.lib.mkForce true; }
          ];
        };
      };
    };
}
