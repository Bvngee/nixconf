{ pkgs, ... }: {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 24;
    gtk.enable = true;
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" "Hack" ]; })
    roboto
  ];
}
