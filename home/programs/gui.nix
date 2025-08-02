{ pkgs, ... }: {
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
    gnome-calendar
    gnome-calculator
    gnome-notes
    gnome-font-viewer
    gnome-control-center # this is NOT intended to be used outside Gnome, but still has some useful features
    file-roller # better default over kde's ark?
    gnome-disk-utility # Udisk graphical front end
    baobab # disk utilization viewer (gtk)
    gparted # partition manager
    seahorse # GUI for managing gnome-keyring entries
    libsForQt5.kcalc
    mission-center
    snapshot
    helvum # pipewire graph thingy
    pavucontrol
    showmethekey # shows keys typed in a little gui

    # Davinci Resolve only lets you use your Studio key on a select # of machines
    # TODO(25.05): for some reason this forces building spidermonkey from
    # source. Has this been fixed yet?
    # (if config.host.hostname == "pc" then davinci-resolve-studio else davinci-resolve)

    # not using: I found this has some broken parts: https://github.com/NixOS/nixpkgs/issues/347150
   # kicad-small # this excludes the kicad-packages3D library: https://gitlab.com/kicad/libraries/kicad-packages3D
  ];

  services = { };
}
