{ config, pkgs, flakeRoot, ... }: {
  home.packages = [ pkgs.ironbar ];
  xdg.configFile."ironbar".source = 
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/ironbar/config";
}
