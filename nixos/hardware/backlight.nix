{ lib, pkgs, config, isMobile, ... }: {
  # If system is not mobile (likely external monitors), install ddcci-driver
  # which controls external monitor brightness using standard brightness protocol.
  #boot = {
  #  extraModulePackages = lib.mkIf (!isMobile) [ config.boot.kernelPackages.ddcci-driver ];
  #  kernelModules = lib.mkIf (!isMobile) [ "ddcci" "ddcci-backlight" ];
  #};

  environment.systemPackages = with pkgs; [
    brightnessctl # Generic screen brightness control
  ];
}
