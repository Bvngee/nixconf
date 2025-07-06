{ lib, ... }: {
  options.profile = {
    hostname = lib.mkOption {
      type = lib.types.str;
    };
    system = lib.mkOption {
      description = "Profile's system architecture";
      example = "x86_64-linux";
      type = lib.types.str;
    };
    stateVersion = lib.mkOption {
      description = "NixOS version that was first installed on this profile's machine";
      example = "x86_64-linux";
      type = lib.types.str;
    };
    mainUser = lib.mkOption {
      description = "The name of the primary user of this system";
      type = lib.types.str;
    };
    mainUserDesc = lib.mkOption {
      description = "The *full* name of the primary user of this system";
      type = lib.types.str;
    };
    mainUserEmail = lib.mkOption {
      description = "The email address of the primary user of this system";
      type = lib.types.str;
    };
    flakeRoot = lib.mkOption {
      description = "The absolute path where this flake is located in the system";
      example = "/home/user/dev/nixconf";
      type = lib.types.str;
    };
    isMobile = lib.mkOption {
      description = "Whether or not the profile's associated machine is a laptop (mobile) or desktop (stationary)";
      default = false;
      type = lib.types.bool;
    };
    isNvidia = lib.mkOption {
      description = "Whether or not the profile's associated machine has an Nvidia GPU. See the profile's individual nixos configuration file for more nvidia-specific settings";
      default = false;
      type = lib.types.bool;
    };
    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
    };
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "America/Los_Angeles";
    };
    theme = {
      variant = lib.mkOption {
        type = lib.types.enum [ "dark" "light" ];
        default = "dark";
        example = "light";
      };
      base16Theme = lib.mkOption {
        description = "name of this profile's base16 theme (see github:tinted-theming/base16-schemes)";
        default = "gruvbox-material-dark-medium";
        type = lib.types.str;
      };
      wallpaper = lib.mkOption {
        description = "Path to wallpaper image";
        default = builtins.fetchurl {
          url = "https://cdna.artstation.com/p/assets/images/images/031/514/156/medium/alena-aenami-budapest.jpg";
          sha256 = "17phdpn0jqv6wk4fcww40s3hlf285yyll2ja31vsic4drbs2nppk";
        };
        type = lib.types.str;
      };
    };
  };
}
