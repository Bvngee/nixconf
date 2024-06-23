{ config, pkgs, ... }: {
  home.packages = [ pkgs.waybar ];

  xdg.configFile."waybar".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.profile.flakeRoot}/home/waybar/config";
}
