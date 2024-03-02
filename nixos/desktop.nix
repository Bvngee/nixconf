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

    # Password manager
    bitwarden
    bitwarden-cli
  ];

  fonts.enableDefaultPackages = true;

  # Used for apps that depend on a dbus secret-service provider
  services.gnome.gnome-keyring.enable = true;

  # Kwallet get's annoying when switching between eg. KDE and Hyprland
  security.pam.services.login.enableKwallet = false;
  security.pam.services.login.enableGnomeKeyring = true;

  # (there's already a polkitd service from somewhere, but I'll keep this anyways)
  # Manage unpriviledged processes' access to priviledged processes
  security.polkit.enable = true;

  # Necessary to set GTK related settings (eg. to set themes)
  programs.dconf.enable = true;

  # Hands out realtime scheduling priority to user processes on demand
  security.rtkit.enable = true;

  # Modify how laptop lidSwitch/powerKey is handled
  services.logind = lib.mkIf (isMobile) {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
  };
}
