{ flakeRoot, config, pkgs, ... }: {
  home.packages = [ pkgs.waybar ];

  xdg.configFile."waybar".source = 
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/waybar/config";
}
