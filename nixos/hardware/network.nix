{ lib, hostname, isMobile, user, ... }: {

  networking.hostName = hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # If I ever have a desktop without ethernet, change this
  networking.networkmanager.enable = isMobile;
  # Add user to networkmanager group
  users.users.${user}.extraGroups = lib.mkIf (isMobile) [ "networkmanager" ];

}
