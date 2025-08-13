{ pkgs, ... }: {
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Original-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    dotIcons.enable = true; # backwards compatibility
  };
}
