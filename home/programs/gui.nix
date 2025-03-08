{ config, pkgs, pkgsUnstable, ... }:
let
  # Cisco PacketTracer: must download Packet_Tracer822_amd64_signed.deb manually
  ptDebPath = /home/jack/Downloads/Packet_Tracer822_amd64_signed.deb;
  ptUnfixed = pkgsUnstable.ciscoPacketTracer8.override {
    packetTracerSource = ptDebPath;
  };
  # fixes some weird collision with zoom-us. See pkgs/by-name/ci/ciscoPacketTracer8/package.nix
  pt = ptUnfixed.overrideAttrs {
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      ln -s ${ptUnfixed}/bin/packettracer8 $out/bin/packettracer8

      runHook postInstall

    '';
  };
in
{
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
    pkgsUnstable.gnome-disk-utility # Udisk graphical front end (TODO: 24.11)
    baobab # disk utilization viewer (gtk)
    gparted # partition manager
    pkgsUnstable.seahorse # GUI for managing gnome-keyring entries (TODO: 24.11)
    libsForQt5.kcalc
    mission-center
    snapshot
    helvum # pipewire graph thingy
    pavucontrol
    showmethekey # shows keys typed in a little gui

    # Davinci Resolve only lets you use your Studio key on a select # of machines
    (if config.profile.hostname == "pc" then davinci-resolve-studio else davinci-resolve)

    # not using: I found this has some broken parts: https://github.com/NixOS/nixpkgs/issues/347150
    # kicad-small # this excludes the kicad-packages3D library: https://gitlab.com/kicad/libraries/kicad-packages3D

    # I need Cisco PacketTracer for CSE 80N, however it requires logging in to
    # netacad.com download the .deb file manually. I don't always need it on
    # every machine
  ] ++ lib.optional (config.profile.hostname == "latitude" || config.profile.hostname == "precision")
    pt;

  services = { };
}
