{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Image, video
    libsForQt5.gwenview
    mpv
    imv
    gimp
    inkscape
    zathura

    # Office Suite
    onlyoffice-bin
    libreoffice

    # Password manager
    # bitwarden
    bitwarden-cli

    # Chat apps
    vesktop
    element-desktop
    cinny-desktop
    fractal
    zulip
    zulip-term

    # Misc/Other
    obs-studio
    firefox
    ungoogled-chromium
    zoom-us
    gnome.gnome-calendar
    gnome.gnome-calculator
    gnome.gnome-notes
    gnome.gnome-font-viewer
    gnome.gnome-control-center # this is NOT intended to be used outside Gnome, but still has some useful features
    gnome.file-roller # better default over kde's ark?
    baobab # disk utilization viewer (gtk)
    libsForQt5.kcalc
    mission-center
    snapshot
    helvum # pipewire graph thingy
    pavucontrol

    # Super heavy apps
    (if config.profile.hostname == "pc" then davinci-resolve-studio else davinci-resolve)

    # not using: I found this has some broken parts: https://github.com/NixOS/nixpkgs/issues/347150
    # kicad-small # this excludes the kicad-packages3D library: https://gitlab.com/kicad/libraries/kicad-packages3D
  ];

  programs = {
  };

  services = {
  };
}
