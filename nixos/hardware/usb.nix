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
  # Adds my user to plugdev and dialout groups
  users.users.${config.profile.mainUser}.extraGroups = [ "plugdev" "dialout" ];

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

    # MPLab Extensions rules for Microship embedded development (attiny)
    # 2017.12.15 Rules file created.
    # ------------- BEGIN --------------
    ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="666"
    # ACTION=="add", SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="0666"

    # 2018.09.11 Remove calls to mchplinusbdevice.
    # 2017.09.25 Added check for Microchip product IDs.
    # 2017.03,03 Added check for Atmel tools.
    # 2012.01.23 Changed SYSFS reference(s) to ATTR.
    # 2011.12.15 Note: Reboot works on all systems to have rules file recognized.
    # 2010.01.26 Add reference to "usb" for Ubuntu.
    # 2010.01.22 Attempt to further simplify rules files requirements.
    # 2009.08.18 Rules file simplified.
    # 2009.07.15 Rules file created.

    ACTION!="add", GOTO="rules_end"
    SUBSYSTEM=="usb_device", GOTO="check_add"
    SUBSYSTEM!="usb", GOTO="rules_end"

    LABEL="check_add"

    ATTR{idVendor}=="04d8", ATTR{idProduct}=="8???", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="9???", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="a0??", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="00e0", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="00e1", MODE="666"
    ATTR{idVendor}=="03eb", ATTR{idProduct}!="6124", MODE="666"

    LABEL="rules_end"
    # -------------  END  --------------
  '';


  environment.systemPackages = with pkgs; [
    solaar # CLI/GUI manager for the Logitech Unifying Receiver

    mow # Glorious Model O Wireless CLI tool
  ];

  services.udev.packages = with pkgs; [
    logitech-udev-rules # supposedly more up to date than what's included with solaar
  ];

}
