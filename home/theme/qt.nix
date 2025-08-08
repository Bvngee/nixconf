{ pkgs, ... }: {
  qt = {
    enable = true;
    # TODO: investigate declarative generation of qt[5,6]ct.conf files.
    # Something like this:
    # https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/10
    platformTheme.name = "qtct";
    style = {
      # name = "breeze";
      package = pkgs.kdePackages.breeze;

      # I haven't found a good-working Kvantum theme... it all seems like a
      # giant hack to me.
      #name = "kvantum";
    };
  };

}
