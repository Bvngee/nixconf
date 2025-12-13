{ ... }: {
  services.kdeconnect = {
    enable = true; # kdeconnectd systemd service
    indicator = true; # Tray component
  };
}
