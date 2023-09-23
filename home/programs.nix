{ pkgs, ... }: {
  home.packages = with pkgs; [
    #image, video
    libsForQt5.gwenview
    mpv
    
    
  ];
}
