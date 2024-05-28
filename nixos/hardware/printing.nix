{ pkgs, ... }: {
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true; # nixos 24.05: nssmdns -> nssmdns4
  services.avahi.openFirewall = true;
  services.system-config-printer.enable = true;

  environment.systemPackages = with pkgs; [
    cups-filters 
  ];
}
