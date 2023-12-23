{ nixpkgs, inputs, ... }:
let
  mkHomeManagerConfiguration = config:
    let
      nixpkgsConf = { # Not sure why this is needed at all? nixpkgs.nix does the same
        config.allowUnfree = true;
        config.allowUnfreePredicate = _: true;
      };
      pkgs = import nixpkgs ({ inherit (config) system; } // nixpkgsConf);
      pkgsUnstable = import inputs.nixpkgs-unstable ({ inherit (config) system; } // nixpkgsConf);
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit (config)
          user
          hostname
          isMobile
          locale
          timezone
          flakeRoot
          base16-theme;
        inherit inputs pkgs pkgsUnstable;
      };
      modules = config.modules;
    };
  commonGraphicalModules = [
    ../../home/home.nix
    ../../home/nixpkgs.nix
    ../../home/xdg.nix
    ../../home/theme/fonts.nix
    ../../home/theme/cursor.nix
    ../../home/theme/gtk.nix
    ../../home/theme/qt.nix
    ../../home/theme/base16.nix
    ../../home/theme/matugen.nix
    ../../home/git.nix
    ../../home/kdeconnect.nix
    ../../home/kitty.nix
    ../../home/dunst.nix
    ../../home/ironbar.nix
    ../../home/spicetify.nix

    ../../home/programs/cli.nix
    ../../home/programs/coding.nix
    ../../home/programs/gui.nix
    ../../home/wayland
    ../../home/shell
    ../../home/nvim
  ];
in
{
  "jack@pc" = mkHomeManagerConfiguration {
    system = "x86_64-linux";
    user = "jack";
    hostname = "pc";
    isMobile = false;
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
    flakeRoot = "/home/jack/dev/nixconf/";
    base16-theme = "gruvbox-material-dark-medium.yaml";
    modules = [
      { home.stateVersion = "23.05"; }
    ] ++ commonGraphicalModules;
  };

  "jack@latitude" = mkHomeManagerConfiguration {
    system = "x86_64-linux";
    user = "jack";
    hostname = "latitude";
    isMobile = true;
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
    flakeRoot = "/home/jack/dev/nixconf/";
    base16-theme = "gruvbox-material-dark-medium.yaml";
    modules = [
      { home.stateVersion = "23.05"; }
    ] ++ commonGraphicalModules;
  };

  "jack@wsl" = mkHomeManagerConfiguration {
    system = "x86_64-linux";
    user = "jack";
    hostname = "latitude";
    isMobile = true;
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
    flakeRoot = "/home/jack/dev/nixconf/";
    base16-theme = "gruvbox-material-dark-medium.yaml";
    modules = [
      { home.stateVersion = "23.05"; }

      ../../home/home.nix
      ../../home/xdg.nix
      ../../home/theme.nix
      ../../home/git.nix
      ../../home/base16.nix

      ../../home/programs/cli.nix
      ../../home/programs/coding.nix
      ../../home/wayland
      ../../home/shell
      ../../home/nvim
    ];
  };
}
