{ config, inputs, pkgs, flakeRoot, ... }:
let
  inherit (builtins) substring stringLength;

  ags = inputs.ags.packages.${pkgs.system}.agsWithTypes;

  homeDir = config.home.homeDirectory;
  flakeRootFromHomeDir = substring (stringLength "${homeDir}/") (-1) flakeRoot;
in
{
  home.packages = [ ags ];

  xdg.configFile."ags".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/ags/config";

  # Links the Ags types folder straight into this directory. Adding it to ~/.condig/ags
  # instead causes errors (mkOOSS throws "outside $HOME"), so unfortunately this must be done
  home.file = {
    "${flakeRootFromHomeDir}/home/ags/config/types" = {
      source = "${ags}/share/com.github.Aylur.ags/types";
      recursive = true;
    };
  };
}
