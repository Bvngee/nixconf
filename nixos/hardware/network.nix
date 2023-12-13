{ ... }: {

  # TODO: modularize
  networking.hostName = "pc";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable = false;

}
