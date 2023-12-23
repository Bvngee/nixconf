{ pkgs, ... }: {

  home.pointerCursor = {
    name = "Bibata-Original-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

}
