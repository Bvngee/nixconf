{ pkgs, ... }: {
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
    lunar-client
    # note: https://github.com/glfw/glfw/issues/2510#issuecomment-2002622024
    # glfw-wayland-minecraft requires __GL_THREADED_OPTIMIZATIONS=0 on nvidia
    (prismlauncher.override { withWaylandGLFW = true; })
  ];
}
