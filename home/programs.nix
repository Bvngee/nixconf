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
    nix-prefetch-scripts
    file
    btop
    htop

    #office-suite
    onlyoffice-bin
    libreoffice

    #games
    prismlauncher

    #Discord
    #(pkgsUnstable.discord.override {
    (pkgs.discord.override {
      withOpenASAR = false;
      withVencord = false;
    })
  ];
}
