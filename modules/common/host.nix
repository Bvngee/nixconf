{ lib, ... }: {
  # Custom host-specific options that every HM / NixOS config has access to
  # for generalizing configurations. Eg: isNvidia, hostname, mainUser, etc.
  # These are mostly specific to host machines. Note that I have some HM
  # configurations which aren't associated with a NixOS system (eg. HM on
  # WSL/Ubuntu), so "host" doesn't necessarily mean "nixos host".

  options.host = {

    hostname = lib.mkOption {
      type = lib.types.str;
    };
    stateVersion = lib.mkOption {
      description = "NixOS version that was first installed on this profile's machine (for managing stateful application data)";
      example = "x86_64-linux";
      type = lib.types.str;
    };

    flakeRoot = lib.mkOption {
      description = "The absolute path where this flake is located in the filesystem";
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
}
