{ isMobile, ... }: {
  # This might change in the future depending on what machines setups I use.
  hardware.bluetooth.enable = isMobile;
}
