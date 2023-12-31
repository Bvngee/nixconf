{ pkgs, inputs, ... }: {
  imports = [
    inputs.nix-gaming.nixosModules.steamCompat
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  nix.settings = {
    # add github:fufexan/nix-gaming cachix
    substituters = [ "https://nix-gaming.cachix.org/" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # nix-gaming specific module
  services.pipewire.lowLatency.enable = true;

  # steam override that allows to work with gamescope
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  programs.steam = {
    enable = true;

    # adds extra compatibility tools to your STEAM_EXTRA_COMPAT_TOOLS_PATHS
    extraCompatPackages = [
      inputs.nix-gaming.packages.${pkgs.system}.proton-ge
    ];
  };

  environment.systemPackages = with pkgs; [
    gamemode
    gamescope # in a Steam game's launch options: `gamescope -W 2560 -H 1440 -- %command%`

    bottles

    mangohud

    protontricks
    winetricks

    # Games
    prismlauncher
    lunar-client
  ];
}
