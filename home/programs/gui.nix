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

    # Password manager
    bitwarden
    bitwarden-cli

    # Chat apps
    vesktop
    #(pkgsUnstable.discord.override {
    #(pkgs.discord.override {
    #  withOpenASAR = false;
    #  withVencord = false;
    #})
    element-desktop
    cinny-desktop
    zulip
    zulip-term

    # Misc/Other
    obs-studio
    firefox
    zoom-us
    gnome.gnome-calendar
    gnome.gnome-calculator
    gnome.gnome-notes
    gnome.gnome-disk-utility
    gnome.gnome-font-viewer
    gnome.gnome-control-center # this is NOT intended to be used outside Gnome, but still has some useful features
    gnome.file-roller # better default over kde's ark?
    libsForQt5.kcalc
    mission-center
    snapshot
    helvum # pipewire graph thingy
    zed-editor
  ];

  programs = {
  };

  services = {
  };
}
