{ hostname, user, ... }: {

  networking.hostName = hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Do I want isMobile only here?
  networking.networkmanager.enable = true;
  users.users.${user}.extraGroups = [ "networkmanager" ];

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

}
