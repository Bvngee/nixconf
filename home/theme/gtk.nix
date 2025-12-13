{ config, pkgs, ... }:
{
  # Notes regarding live-switching between dark and light mode at runtime (which I currently do not do):
  # 1) config.gtk.theme.* must not be set, to avoid theme name being set in gtk-x.0/settings.ini.
  # 2) `dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3-dark'"`,
  #    `dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"`, and
  #    `dconf write /org/gnome/desktop/interface/icon-theme "'Colloid-dark'"` can be used to perform the reload.
  # 3) It is currently NOT possible to theme dark and light mode with named variables AND live-switch between them
  #    (unless libadwaita-without-adwaita (AUR) becomes an actual thing?).

  home.packages = with pkgs; [
    adw-gtk3 # GTK3/4
    gnome-themes-extra # GTK2 only
  ];

  gtk = {
    enable = true;

    cursorTheme = {
      # Same as `home.pointerCursor.gtk.enable = true`
      inherit (config.home.pointerCursor) name package size;
    };

    font = {
      # Should I provide a default size?
      name = "Inter";
      package = pkgs.inter;
    };
    # Setting theme here adds it to gtk-2.0/gtkrc and gtk-[3|4].0/settings.ini, though I use different for both.
    #theme = {
    #  name = "adw-gtk3-dark";
    #  package = pkgs.adw-gtk3;
    #};
    iconTheme =
      let
        # https://github.com/vinceliuice/Colloid-icon-theme/tree/main/src/places/scalable
        themedColloid = (pkgs.colloid-icon-theme.override {
          colorVariants = [ "default" "grey" ]; # I think I like default better?
          schemeVariants = [ "nord" ]; # Slightly more mute colors than default
        }).overrideAttrs {
          version = "372464b";
          src = pkgs.fetchFromGitHub {
            owner = "vinceliuice";
            repo = "Colloid-icon-theme";
            rev = "372464bf2c1f037baf86e338b633fcdec87c76f4";
            hash = "sha256-FZ3WUAQH80eteUO/+MJUuwEN8D43pQ8qrq+XBz2TiXM=";
          };

          patches = [
            # https://github.com/vinceliuice/Colloid-icon-theme/issues/167#issuecomment-3649125204
            ./remove_broken_links.txt
            # Personal preference, I prefer original, app-provided app Icons.
            # Note that some apps not being visible in launchers like Fuzzel is
            # nixpkgs' fault, not ours: https://github.com/NixOS/nixpkgs/issues/428824
            ./disable_all_apps.txt
          ];
        };
      in
      {
        name = "Colloid-Nord-Dark"; # "Colloid-grey-light"
        package = themedColloid;
      };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    # Not sure if all this antialising and hinting stuff is necessary. Taken from NotAShelf
    gtk2.extraConfig = ''
      # I don't trust gtk2 apps to handle theming
      # gtk-theme-name="Adwaita-dark" # Adwaita
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
    gtk4.extraConfig = { };
    # In nixpkgs latest, this line is automatically added to gtk4.css. Since many gtk4 apps hardcode LibAdwaita theming, this is
    # necessary to load other themes. But since I'm just using a colored libadwaita, it shouldn't (I think?) be necessary.
    # https://github.com/nix-community/home-manager/blob/433120e47d016c9960dd9c2b1821e97d223a6a39/modules/misc/gtk.nix#L244C9-L244C99
    #gtk4.extraCss = ''
    #  @import url("file://${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css");
    #'';
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = 1;
  };

  # Set default dconf database values. dconf settings for cursor theme, font, and
  # icon theme, are all set by the gtk module.
  dconf.settings = {
    # prefer dark or light mode
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3-dark";
      color-scheme = "prefer-dark";
      # gtk-theme = "adw-gtk3";
      # color-scheme = "prefer-light";
    };

    # yeet close/maximize/minimize buttons
    # https://www.reddit.com/r/hyprland/comments/16nslna/remove_buttons_on_gtk_apps/
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "icon,appmenu:";
    };
  };

}
