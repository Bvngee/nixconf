{ config, ... }: {

  networking.hostName = config.profile.hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Do I want isMobile only here?
  networking.networkmanager.enable = true;
  users.users.${config.profile.mainUser}.extraGroups = [ "networkmanager" ];

  # spams annoying notifications, tray menu is barely useful
  # programs.nm-applet = {
  #   enable = false;
  #   indicator = true;
  # };

}
