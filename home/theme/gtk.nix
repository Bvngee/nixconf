{ config, lib, pkgs, user, theme, ... }: let
    c = config.programs.matugen.theme.colors.colors.${theme.variant};
    cu = import ./color-utils.nix { inherit lib; };
    inherit (cu) hexToRgba;
in {

  # Notes regarding live-switching between dark and light mode at runtime (which I currently do not do):
  # 1) config.gtk.theme.* must not be set, to avoid theme name being set in gtk-x.0/settings.ini.
  # 2) `dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3-dark'"`,
  #    `dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"`, and
  #    `dconf write /org/gnome/desktop/interface/icon-theme "'Colloid-dark'"` can be used to perform the reload.
  # 3) It is currently NOT possible to theme dark and light mode with named variables AND live-switch between them.
  # 

  home.packages = with pkgs; [
    adw-gtk3                 # GTK3/4
    gnome.gnome-themes-extra # GTK2 only

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
    # Setting theme here adds it to gtk-2.0/gtkrc and gtk-[3|4].0/settings.ini, though I use different for both.
    #theme = {
    #  name = "adw-gtk3-dark";
    #  package = pkgs.adw-gtk3;
    #};
    iconTheme = {
      #Colloid-grey-dark and Colloid-grey-light for grey folder icons
      name = if (theme.variant == "dark") then "Colloid-dark" else "Colloid";
      package = pkgs.colloid-icon-theme.overrideAttrs { # possibly rm -rf /apps folder later?
        # In theory, this should make the color of the folder icons follow the matugen theme
        # hopefully it doesn't slow things down too much? Reference:
        # TODO: add reference script
        # FIXME: NOT CURRENTLY WORKING
        configurePhase = ''
          sed -i "s/#5b9bf8/${c.inverse_primary}/g" "./src/places/scalable/"*".svg"
        '';
      };
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    # Not sure if all this antialising and hinting stuff is necessary. Taken from NotAShelf
    gtk2.extraConfig = ''
      gtk-theme-name="${if (theme.variant == "dark") then "Adwaita-dark" else "Adwaita"}"
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
  # Set default dconf database values to prefer dark mode.
  # dconf settings for cursor theme, font, and icon theme, are all set by the gtk module.
  dconf.settings."org/gnome/desktop/interface" = if (theme.variant == "dark") then {
    gtk-theme = "adw-gtk3-dark";
    color-scheme = "prefer-dark";
    icon-theme = "Colloid-dark";
  } else {
    gtk-theme = "adw-gtk3";
    color-scheme = "prefer-light";
    icon-theme = "Colloid";
  };

  # Theming GTK's LibAdwaita via Matugen and named variables.
  gtk.gtk4.extraCss = config.gtk.gtk3.extraCss;
  gtk.gtk3.extraCss = ''
    /* NOTES:
    ** view_bg_color is for main/central windows, which is set to be the darkest color (c.surface).
    ** window_bg_color is mainly side/secondary panels, so it set to be slightly brighter (a mix
    ** between c.surface and c.secondary_container). headerbar_bg_color matches window_bg_color.
    */
    @define-color accent_color ${c.primary};
    @define-color accent_bg_color ${c.primary};
    @define-color accent_fg_color ${c.on_primary};
    @define-color destructive_color ${c.error};
    @define-color destructive_bg_color ${c.error_container};
    @define-color destructive_fg_color ${c.on_error_container};
    @define-color success_color ${c.tertiary};
    @define-color success_bg_color ${c.tertiary_container};
    @define-color success_fg_color ${c.on_tertiary_container};
    @define-color warning_color ${c.secondary};
    @define-color warning_bg_color ${c.secondary_container};
    @define-color warning_fg_color ${c.on_secondary_container};
    @define-color error_color ${c.error};
    @define-color error_bg_color ${c.error_container};
    @define-color error_fg_color ${c.on_error_container};
    @define-color window_bg_color mix(${c.secondary_container}, ${c.surface}, 0.7); /* should be slightly brighter than surface */
    @define-color window_fg_color ${c.on_surface};
    @define-color view_bg_color ${c.surface}; /* {c.secondary_container} is too bright for this */
    @define-color view_fg_color ${c.on_surface};
    /* OLD: {hexToRgba c.primary "0.05"} NEW: {c.secondary_container} */
    @define-color headerbar_bg_color @window_bg_color;
    @define-color headerbar_fg_color ${c.on_secondary_container};
    @define-color headerbar_border_color ${hexToRgba c.on_surface "0.8"};
    @define-color headerbar_backdrop_color @headerbar_bg_color; /* This should disable fade on lost focus */
    @define-color headerbar_shade_color ${hexToRgba c.on_surface "0.07"};
    @define-color card_bg_color ${hexToRgba c.primary "0.05"};
    @define-color card_fg_color ${c.on_secondary_container};
    @define-color card_shade_color ${hexToRgba c.shadow "0.07"};
    @define-color thumbnail_bg_color ${c.secondary_container};
    @define-color thumbnail_fg_color ${c.on_secondary_container};
    @define-color dialog_bg_color ${c.secondary_container};
    @define-color dialog_fg_color ${c.on_secondary_container};
    @define-color popover_bg_color ${c.secondary_container};
    @define-color popover_fg_color ${c.on_secondary_container};
    @define-color shade_color ${hexToRgba c.shadow (if theme.variant == "light" then "0.07" else "0.36")};
    @define-color scrollbar_outline_color ${hexToRgba c.outline (if theme.variant == "light" then "1.0" else "0.5")};

    @define-color sidebar_bg_color @window_bg_color;
    @define-color sidebar_fg_color @window_fg_color;
    @define-color sidebar_border_color @window_bg_color;
    @define-color sidebar_backdrop_color @window_bg_color;
  '';
}
