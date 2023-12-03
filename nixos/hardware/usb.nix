{ ... }: {
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", MODE="0664", GROUP="plugdev"
  '';

  # creates plugdev group
  users.groups.plugdev = {};

  # adds my user to group
  # TODO: make dependent on passed in profile settings!!
  users.users.jack.extraGroups = [ "plugdev" ];
}
