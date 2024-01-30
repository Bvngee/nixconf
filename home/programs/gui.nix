{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Image, video
    libsForQt5.gwenview
    mpv
    imv
    gimp

    # Office Suite
    onlyoffice-bin
    libreoffice

    # Discord
    vesktop
    #(pkgsUnstable.discord.override {
    #(pkgs.discord.override {
    #  withOpenASAR = false;
    #  withVencord = false;
    #})
    vesktop

    # Misc/Other
    obs-studio
    firefox
    zoom-us
    gnome.gnome-calculator
    libsForQt5.kcalc
    mission-center
    snapshot
  ];
}
