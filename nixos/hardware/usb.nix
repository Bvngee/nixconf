{ user, ... }: {
  # This allows the user to access certain USB devices. My particular usecase
  # was using a Microbit in the browser via the WebUSB protocol.

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", MODE="0664", GROUP="plugdev"
  '';

  # creates plugdev group
  users.groups.plugdev = {};

  # adds my user to group
  users.users.${user}.extraGroups = [ "plugdev" ];
}
