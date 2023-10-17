{ pkgs, config, ... }: {
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
