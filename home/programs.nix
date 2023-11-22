{ pkgs, ... }: {
  home.packages = with pkgs; [
    #image, video
    libsForQt5.gwenview
    mpv
    
    #cli - maybe move to home/shell later?
    ripgrep
    fd
    nix-prefetch-scripts
    file
    btop
    htop
    neofetch

    #programming language tooling
    temurin-jre-bin-18

    #office-suite
    onlyoffice-bin
    libreoffice

    #Discord
    #(pkgsUnstable.discord.override {
    (pkgs.discord.override {
      withOpenASAR = false;
      withVencord = false;
    })

    #games
    prismlauncher

    #misc GUI
    obs-studio
    firefox
    jetbrains.idea-community
    vscodium-fhs
  ];
}
