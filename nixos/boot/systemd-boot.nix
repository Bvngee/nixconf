{ ... }: {
  # systemd-boot only works with UEFI systems.

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.consoleMode = "max"; # might depend on screen
  boot.loader.efi.canTouchEfiVariables = true;
}
