{ inputs, pkgs, config, ... }: {
  imports = [ 
    inputs.base16.homeManagerModule
    {
      home.packages = let
        printScheme = with config.scheme.withHashtag; 
          pkgs.writeShellScriptBin "printScheme" ''
            echo "
              base00 = "${base00}",
              base01 = "${base01}",
              base02 = "${base02}",
              base03 = "${base03}",
              base04 = "${base04}",
              base05 = "${base05}",
              base06 = "${base06}",
              base07 = "${base07}",
              base08 = "${base08}",
              base09 = "${base09}",
              base0A = "${base0A}",
              base0B = "${base0B}",
              base0C = "${base0C}",
              base0D = "${base0D}",
              base0E = "${base0E}",
              base0F = "${base0F}",
            " | nvim
          '';
      in [ printScheme ];
    }
  ];

  # base16.nix scheme
  scheme = let
    base16-schemes = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "base16-schemes";
      rev = "a9112eaae86d9dd8ee6bb9445b664fba2f94037a";
      hash = "sha256-5yIHgDTPjoX/3oDEfLSQ0eJZdFL1SaCfb9d6M0RmOTM=";
    };
  in "${base16-schemes}/gruvbox-material-dark-medium.yaml"; #nord

  

  # other theme-related stuff

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "bibata-original-classic";
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
