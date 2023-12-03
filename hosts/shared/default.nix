{ inputs, lib, config, pkgs, ... }: 

{
  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
    #font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24n.psf.gz";
    keyMap = "us";
  };

  users.users.jack = {
    isNormalUser = true;
    description = "Jack Nystrom";
    extraGroups = [ "wheel" "networkmanager" "plugdev" ]; # "input" "uinput"
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true; # needs to be in system config
  environment.pathsToLink = [ "/share/zsh" ]; # apparently needed for completion of system packages?

  environment.systemPackages = with pkgs; [
    git
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;

    # add flake inputs as registrys to make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # add flake inputs to system's legacy channels to make legacy nix- commands consistent too
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      # stop warning me that the git tree is dirty, bruh.
      warn-dirty = false;
    };
  };
}
