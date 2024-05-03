{ pkgs, ... }: {
  nix.settings = {
    # add github:fufexan/nix-gaming cachix
    substituters = [ "https://nix-gaming.cachix.org/" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  programs.steam = {
    enable = true;

    # in a Steam game's launch options: `gamescope -W 2560 -H 1440 -- %command%`
    gamescopeSession.enable = true;

    # steam override that allows to work with gamescope # is this needed?
    package = pkgs.steam.override {
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
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    gamescope 

    mangohud

    protontricks
    winetricks
    wine # wine-wayland ?

    # Games
    # (prismlauncher.override { withWaylandGLFW = true; }) # not in 23.11
    prismlauncher
    lunar-client
  ];
}
