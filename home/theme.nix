{ inputs, pkgs, config, ... }: {
  imports = [ inputs.base16.homeManagerModule ];

  # base16.nix scheme
  scheme = let
    base16-schemes = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "base16-schemes";
      rev = "a9112eaae86d9dd8ee6bb9445b664fba2f94037a";
      hash = "sha256-5yIHgDTPjoX/3oDEfLSQ0eJZdFL1SaCfb9d6M0RmOTM=";
    };
  in "${base16-schemes}/gruvbox-material-dark-medium.yaml";

  

  # other theme-related stuff

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" "Hack" ]; })
    roboto
  ];

  gtk = {
    enable = true;
    #font = {
    #};
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    #theme = {
    #};
  };
}
