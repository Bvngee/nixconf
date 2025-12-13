{ ... }: {
  programs = {
    # Opens TCP/UDP ports for kdeconnect and adds package to systemPackages
    kdeconnect.enable = true;
  };
}
