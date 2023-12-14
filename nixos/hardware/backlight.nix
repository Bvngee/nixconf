{ lib, pkgs, config, isMobile, ... }: {
  # If system is not mobile (likely external monitors), install ddcci-driver
  # which controls external monitor brightness using standard brightness protocol.
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      lib.mkIf (!isMobile) ddcci-driver
    ];
    kernelModules = lib.mkIf (!isMobile) [ "ddcci" "ddcci-backlight" ];
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
