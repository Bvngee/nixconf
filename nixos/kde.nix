{ lib, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Kwallet get's annoying when switching between eg. KDE and Hyprland
  # TODO: does this break anything?
  security.pam.services.login.enableKwallet = lib.mkForce false;
  security.pam.services.login.enableGnomeKeyring = true;
}
