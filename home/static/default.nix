{ inputs, config, pkgs, ... }:
let
  mkLink = relPath:
    config.lib.file.mkOutOfStoreSymlink "${config.profile.flakeRoot}/home/static/files/${relPath}";
in
{
  # Some necessary packages related to the static files
  home.packages = with pkgs; [
    inputs.nixpkgs-ironbar.legacyPackages.${pkgs.system}.ironbar
    yazi
    joshuto
  ];

  xdg.configFile = {
    "ironbar".source = mkLink "ironbar";
    "joshuto".source = mkLink "joshuto";
    "hypr/hyprland.conf".source = mkLink "hypr/hyprland.conf";
    "starship.toml".source = mkLink "starship.toml";
    "btop/btop.conf".source = mkLink "btop/btop.conf";
  };

  home.file = {
    ".local/bin".source = mkLink "bin";
  };
}
