{ lib, pkgs, config, ... }:
let
  mow = pkgs.rustPlatform.buildRustPackage {
    pname = "mow";
    version = "4452efd";

    src = pkgs.fetchFromGitHub {
      owner = "korkje";
      repo = "mow";
      rev = "4452efd6b8e3c072e1996ff0fdaa3dab7967d3dd";
      hash = "sha256-OZm7zK7uKN6nJeq/R/jl+tpGc0a33fFEhfyQGZOmSM0=";
    };

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ libusb1 ];

    cargoHash = "sha256-5DqwOcrW2CgsWcCUY9XPXpPaell+VoiCBaHwIFJeMfs=";

    meta = {
      description = "Cross platform CLI tool for Model O Wireless";
      homepage = "https://github.com/korkje/mow";
      license = lib.licenses.mit;
    };
  };
in
{

  # Creates plugdev group
  users.groups.plugdev = { };
  # Adds my user to group
  users.users.${config.profile.mainUser}.extraGroups = [ "plugdev" ];

  # Allows users in plugdev group to access certain USB devices. 
  services.udev.extraRules = ''
    # Microbit (for use in the browser via the WebUSB)
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0d28", MODE="0664", GROUP="plugdev"

    # https://github.com/stlink-org/stlink/tree/testing/config/udev/rules.d
    # STM32 nucleo boards, with onboard st/linkv2-1. ie, STM32F0, STM32F4.
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374a", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2-1_%n"
    # STM32 discovery boards, with onboard st/linkv2. ie, STM32L, STM32F4.
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2_%n"
  '';


  environment.systemPackages = with pkgs; [
    solaar # CLI/GUI manager for the Logitech Unifying Receiver

    mow # Glorious Model O Wireless CLI tool
  ];

  services.udev.packages = with pkgs; [
    logitech-udev-rules # supposedly more up to date than what's included with solaar
  ];

}
