{ ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #services.gnome.core-utilities.enable = false;
}
