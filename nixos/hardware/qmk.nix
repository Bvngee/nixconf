{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    qmk
    vial
  ];

  hardware.keyboard.qmk.enable = true; # Adds pkgs.qmk-udev-rules to udev
  services.udev.packages = with pkgs; [
    vial
  ];
}
