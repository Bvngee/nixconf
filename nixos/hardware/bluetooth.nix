{ isMobile, ... }: {
  # Enable bluetooth if isMobile (may very well change in the future)
  hardware.bluetooth.enable = isMobile;
  hardware.bluetooth.powerOnBoot = isMobile; # TODO: Do I want this?
  services.blueman.enable = true; # useful for non-DE sessions
}
