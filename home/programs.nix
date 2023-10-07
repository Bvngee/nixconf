{ pkgs, ... }: {
  home.packages = with pkgs; [
    #image, video
    libsForQt5.gwenview
    mpv
    
    obs-studio
    
    firefox

    #cli - maybe move to home/shell later?
    ripgrep
    fd
    
  ];
}
