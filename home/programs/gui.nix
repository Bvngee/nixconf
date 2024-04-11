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

    # Chat apps
    vesktop
    #(pkgsUnstable.discord.override {
    #(pkgs.discord.override {
    #  withOpenASAR = false;
    #  withVencord = false;
    #})
    element-desktop
    cinny-desktop

    # Misc/Other
    obs-studio
    firefox
    zoom-us
    gnome.gnome-calendar
    gnome.gnome-calculator
    gnome.gnome-notes
    gnome.gnome-disk-utility # nixos only?
    gnome.file-roller # replace ark?
    libsForQt5.kcalc
    mission-center
    snapshot
    helvum # pipewire graph thingy
  ];
}
