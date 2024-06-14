{ config, pkgs, flakeRoot, ... }:
let
  mkLink = relPath:
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/static/files/${relPath}";
in
{
  # Some necessary packages related to the static files
  home.packages = with pkgs; [
    ironbar
    yazi
    joshuto
  ];

  xdg.configFile = {
    "ironbar".source = mkLink "ironbar";
    "joshuto".source = mkLink "joshuto";
    "hypr/hyprland.conf".source = mkLink "hypr/hyprland.conf";
    "starship.toml".source = mkLink "starship.toml";
  };

  home.file = {
    ".local/bin".source = mkLink "bin";
  };
}
