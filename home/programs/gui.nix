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

    # Misc/Other
    obs-studio
    firefox
    zoom-us
    gnome.gnome-calculator
    gnome.gnome-notes
    gnome.gnome-disk-utility # nixos only?
    gnome.file-roller # replace ark?
    libsForQt5.kcalc
    mission-center
    snapshot
    element-desktop
    cinny-desktop
  ];
}
