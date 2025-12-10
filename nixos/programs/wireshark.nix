{ pkgs, config, ... }: {
  programs.wireshark = {
    package = pkgs.wireshark;
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  users.users.${config.host.mainUser}.extraGroups = [ "wireshark" ];
}
