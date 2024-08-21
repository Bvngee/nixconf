{ nixpkgs, inputs, ... }:
let
  nixpkgsConf = {
    # Not sure why this is needed at all? nixpkgs.nix does the same
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;
  };

  mkHomeManagerConfig = { system, imports }:
    let
      pkgs = import nixpkgs ({ inherit system; } // nixpkgsConf);
      pkgsUnstable = import inputs.nixpkgs-unstable ({ inherit system; } // nixpkgsConf);
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = imports;
      extraSpecialArgs = { inherit inputs pkgs pkgsUnstable; };
    };

  commonGraphicalHMModules = [
    ../modules # source custom modules

    ../home/home.nix
    ../home/nixpkgs.nix
    ../home/xdg.nix
    ../home/git.nix
    ../home/kdeconnect.nix
    ../home/kitty.nix
    ../home/ghostty.nix
    ../home/dunst.nix
    ../home/spicetify.nix
    ../home/thunar.nix
    ../home/theme/fonts.nix
    ../home/theme/cursor.nix
    ../home/theme/gtk.nix
    ../home/theme/qt.nix
    ../home/theme/base16.nix
    ../home/theme/matugen.nix

    ../home/programs/cli.nix
    ../home/programs/coding.nix
    ../home/programs/gui.nix
    ../home/wayland
    ../home/x11
    ../home/shell
    ../home/waybar
    ../home/nvim
    ../home/ags
    ../home/static
  ];
in
{
  "jack@pc" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ./pc/profile.nix
    ] ++ commonGraphicalHMModules;
  };
  "jack@latitude" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ./latitude/profile.nix
    ] ++ commonGraphicalHMModules;
  };
  "jack@precision" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ./precision/profile.nix
    ] ++ commonGraphicalHMModules;
  };
  # todo:
  # "jack@wsl" = mkHomeManagerConfig {
  # };
}
