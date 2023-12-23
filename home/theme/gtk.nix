{ config, pkgs, user, ... }: 
{

  # Install GTK theme here to avoid it being set in gtk-x.0/settings.ini
  home.packages = with pkgs; [
    adw-gtk3

    gradience
  ];

  gtk = {
    enable = true;

    cursorTheme = { 
      inherit (config.home.pointerCursor) name package size; 
    };

    font = {
      name = "Inter";
      package = pkgs.inter;
      # Should I provide a default size?
    };
    # Don't set theme here, otherwise it will get added to gtk-x.0/settings.ini, breaking
    # automatic reloading (dark <-> light mode). dconf will be used to set the theme.
    #theme = {
    #  name = "adw-gtk3-dark";
    #  package = pkgs.adw-gtk3;
    #};
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    # Not sure if all this antialising and hinting stuff is necessary. Taken from NotAShelf
    gtk2.extraConfig = ''
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
      gtk-decoration-layout = "menu:";
    };
    gtk3.bookmarks = [
      "file:///home/${user}/Desktop"
      "file:///home/${user}/Documents"
      "file:///home/${user}/Downloads"
      "file:///home/${user}/Videos"
      "file:///home/${user}/Pictures"
    ];
    gtk4.extraConfig = {
      gtk-decoration-layout = "menu:";
    };
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
  # Set default dconf database values to prefer dark mode. Both values will be controlled at runtime.
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "adw-gtk3-dark";
    color-scheme = "prefer-dark";
    # dconf settings for cursor theme, font, and icon theme, are all set by the gtk module.
  };



  # GTK3/4 `gtk.css` template using Matugen
  # Not currently using this, as:
  # 1) I'm not happy with the Matugen's output; it varies way too much
  #    from what Gradience or material_color_utilities_python produces
  # 2) Material color palettes clash harshly with all base16 schemes
  # 3) Custom GTK themes disallow live-switching from dark <-> light
  #    modes (why? ISTG this should be possible. Maybe it's just not.)

  #gtk.gtk4.extraCss = config.gtk.gtk3.extraCss;
  #gtk.gtk3.extraCss = let
  #  inherit (config.programs.matugen) variant;
  #  c = config.programs.matugen.theme.colors.colors.${variant};
  #in ''
  #  @define-color accent_color ${c.primary};
  #  @define-color accent_bg_color ${c.primary};
  #  @define-color accent_fg_color ${c.on_primary};
  #  @define-color destructive_color ${c.error};
  #  @define-color destructive_bg_color ${c.error_container};
  #  @define-color destructive_fg_color ${c.on_error_container};
  #  @define-color success_color ${c.tertiary};
  #  @define-color success_bg_color ${c.tertiary_container};
  #  @define-color success_fg_color ${c.on_tertiary_container};
  #  @define-color warning_color ${c.secondary};
  #  @define-color warning_bg_color ${c.secondary_container};
  #  @define-color warning_fg_color ${c.on_secondary_container};
  #  @define-color error_color ${c.error};
  #  @define-color error_bg_color ${c.error_container};
  #  @define-color error_fg_color ${c.on_error_container};
  #  @define-color window_bg_color ${c.surface};
  #  @define-color window_fg_color ${c.on_surface};
  #  @define-color view_bg_color ${c.secondary_container};
  #  @define-color view_fg_color ${c.on_surface};
  #  @define-color headerbar_bg_color ${c.secondary_container};
  #  @define-color headerbar_fg_color ${c.on_secondary_container};
  #  @define-color headerbar_border_color ${c.on_surface}50;
  #  @define-color headerbar_backdrop_color @window_bg_color;
  #  @define-color headerbar_shade_color ${c.on_surface}07;
  #  @define-color card_bg_color ${c.primary}05;
  #  @define-color card_fg_color ${c.on_secondary_container};
  #  @define-color card_shade_color ${c.shadow}07;
  #  @define-color dialog_bg_color ${c.secondary_container};
  #  @define-color dialog_fg_color ${c.on_secondary_container};
  #  @define-color popover_bg_color ${c.secondary_container};
  #  @define-color popover_fg_color ${c.on_secondary_container};
  #  @define-color shade_color ${c.shadow}24;
  #  @define-color scrollbar_outline_color ${c.outline}32;

  #  @define-color sidebar_bg_color @window_bg_color;
  #  @define-color sidebar_fg_color @window_fg_color;
  #  @define-color sidebar_border_color @window_bg_color;
  #  @define-color sidebar_backdrop_color @window_bg_color;
  #'';
}
