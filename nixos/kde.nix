{ lib, ... }: {
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Kwallet get's annoying when switching between eg. KDE and Hyprland
  # TODO: does this break anything?
  security.pam.services.login.kwallet.enable = lib.mkForce false;
  security.pam.services.kde.kwallet.enable = lib.mkForce false;
}
