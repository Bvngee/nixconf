{ inputs, lib, config, pkgs, ... }: 

{
  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  users.users.jack = {
    isNormalUser = true;
    description = "Jack Nystrom";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  environment.systemPackages = with pkgs; [
    tree
    vim
  ];

  nix = {
    package = pkgs.nixFlakes;

    # add flake inputs as registrys to make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # add flake inputs to system's legacy channels to make legacy nix- commands consistent too
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
}
