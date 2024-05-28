{ lib, pkgs, timezone, locale, isMobile, ... }: {
  # Common configurations shared between all desktop-nixos variations.

  time.timeZone = timezone;
  i18n.defaultLocale = locale;

  console = {
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
    #font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24n.psf.gz";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    git # Useful when debugging
    home-manager # TODO: figure out if this is right (HM as NixOS module instead?)
  ];

  fonts.enableDefaultPackages = true;

  # Used for apps that depend on a dbus secret-service provider
  services.gnome.gnome-keyring.enable = true; # prefer this over Kwallet
  # Let pam_gnome_keyring auto-unlock the user's default gnome keyring on login
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.tuigreet.enableGnomeKeyring = true;

  # (there's already a polkitd service from somewhere, but I'll keep this anyways)
  # Manage unpriviledged processes' access to priviledged processes
  security.polkit.enable = true;

  # Necessary to set GTK related settings (eg. to set themes)
  programs.dconf.enable = true;

  # Dbus service for accessing info about user accounts
  services.accounts-daemon.enable = true;

  # Hands out realtime scheduling priority to user processes on demand
  security.rtkit.enable = true;

  # Enable screen lockers to actually unlock the screen (are these really needed?)
  security.pam.services.hyprlock = { };
  security.pam.services.swaylock = { };

  # Dbus service that allows applications to query and manipulate storage devices
  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true; # mounts drives at /media/ instead of /run/media/$user

  # A system profiler app (not even sure if I'll use this but it looks neat)
  services.sysprof.enable = true;

  # Modify how laptop lidSwitch/powerKey is handled
  services.logind = lib.mkIf (isMobile) {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
  };
}
