{ hostname, user, ... }: {

  networking.hostName = hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Do I want isMobile only here?
  networking.networkmanager.enable = true;
  users.users.${user}.extraGroups = [ "networkmanager" ];

  # spams annoying notifications, tray menu is barely useful
  # programs.nm-applet = {
  #   enable = false;
  #   indicator = true;
  # };

}
