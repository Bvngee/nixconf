{ config, ... }: {
  # Enable bluetooth if isMobile (may very well change in the future)
  hardware.bluetooth.enable = config.profile.isMobile;
  hardware.bluetooth.powerOnBoot = false; # TODO: Do I want this?
  services.blueman.enable = true; # useful for non-DE sessions
}
