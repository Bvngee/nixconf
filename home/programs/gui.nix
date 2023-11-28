{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Image, video
    libsForQt5.gwenview
    mpv

    # Office Suite
    onlyoffice-bin
    libreoffice

    # Discord
    #(pkgsUnstable.discord.override {
    #(pkgs.discord.override {
    #  withOpenASAR = false;
    #  withVencord = false;
    #})

    # Games
    prismlauncher

    # Misc/Other
    obs-studio
    firefox
  ];
}
