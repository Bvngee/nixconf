{ config, pkgs, ... }: {
  home.packages = [ pkgs.waybar ];

  xdg.configFile."waybar".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.host.flakeRoot}/home/waybar/config";
}
