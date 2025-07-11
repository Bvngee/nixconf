{ config, lib, pkgs, ... }:
let
  inherit (config.profile) theme;
  # c = config.programs.matugen.theme.colors.colors.${theme.variant};
  # cu = import ./color-utils.nix { inherit lib; };
  # inherit (cu) hexToRgba;
in
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

    gradience # Not used to theme, but the GUI is nice for testing
  ];

  gtk = {
    enable = true;

    cursorTheme = {
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
        # Changes the color of folder icons to match the matugen theme, as well as removing
        # all custom App icons (personal pref). Unfortunately requires rebuilding the package
        # every time themes are switched. ¯\_(ツ)_/¯
        # https://github.com/vinceliuice/Colloid-icon-theme/tree/main/src/places/scalable
        themedColloid = (pkgs.colloid-icon-theme.override {
          colorVariants = [ "grey" ];
        }).overrideAttrs {
          #          configurePhase = ''
          #            sed -i "s/#888888/${c.inverse_primary}/g" "./colors/color-grey/"*".svg"
          #          '';
          #          # TODO: this part is not working
          #          fixupPhase = ''
          #            rm -rf apps
          #          '';
        };
      in
      {
        name =
          if (theme.variant == "dark")
          then "Colloid-grey-dark"
          else "Colloid-grey-light";
        package = themedColloid;
      };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    # Not sure if all this antialising and hinting stuff is necessary. Taken from NotAShelf
    gtk2.extraConfig = ''
      # I don't trust gtk2 apps to handle theming
      # gtk-theme-name="${if (theme.variant == "dark") then "Adwaita-dark" else "Adwaita"}"
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
    gtk4.extraConfig = {
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

  # Set default dconf database values. dconf settings for cursor theme, font, and
  # icon theme, are all set by the gtk module.
  dconf.settings = {
    # prefer dark or light mode
    "org/gnome/desktop/interface" =
      if (theme.variant == "dark") then {
        gtk-theme = "adw-gtk3-dark";
        color-scheme = "prefer-dark";
      } else {
        gtk-theme = "adw-gtk3";
        color-scheme = "prefer-light";
      };

    # yeet close/maximize/minimize buttons
    # https://www.reddit.com/r/hyprland/comments/16nslna/remove_buttons_on_gtk_apps/
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "icon,appmenu:";
    };
  };

  # Theming GTK's LibAdwaita via Matugen and named variables.
  #  gtk.gtk4.extraCss = config.gtk.gtk3.extraCss;
  #  gtk.gtk3.extraCss = ''
  #    /* NOTES:
  #    ** view_bg_color is for main/central windows, which is set to be the darkest color (c.surface).
  #    ** window_bg_color is mainly side/secondary panels, so it set to be slightly brighter (a mix
  #    ** between c.surface and c.secondary_container). headerbar_bg_color matches window_bg_color.
  #    */
  #    @define-color accent_color ${c.primary};
  #    @define-color accent_bg_color ${c.primary};
  #    @define-color accent_fg_color ${c.on_primary};
  #    @define-color destructive_color ${c.error};
  #    @define-color destructive_bg_color ${c.error_container};
  #    @define-color destructive_fg_color ${c.on_error_container};
  #    @define-color success_color ${c.tertiary};
  #    @define-color success_bg_color ${c.tertiary_container};
  #    @define-color success_fg_color ${c.on_tertiary_container};
  #    @define-color warning_color ${c.secondary};
  #    @define-color warning_bg_color ${c.secondary_container};
  #    @define-color warning_fg_color ${c.on_secondary_container};
  #    @define-color error_color ${c.error};
  #    @define-color error_bg_color ${c.error_container};
  #    @define-color error_fg_color ${c.on_error_container};
  #    @define-color window_bg_color mix(${c.secondary_container}, ${c.surface}, 0.6); /* should be slightly brighter than surface */
  #    @define-color window_fg_color ${c.on_surface};
  #    @define-color view_bg_color ${c.surface}; /* {c.secondary_container} is too bright for this */
  #    @define-color view_fg_color ${c.on_surface};
  #    @define-color headerbar_bg_color @window_bg_color; /* OLD: {hexToRgba c.primary "0.05"} NEW: {c.secondary_container} */
  #    @define-color headerbar_fg_color ${c.on_secondary_container};
  #    @define-color headerbar_border_color ${hexToRgba c.on_surface "0.8"};
  #    @define-color headerbar_backdrop_color @headerbar_bg_color; /* This should disable fade on lost focus */
  #    @define-color headerbar_shade_color ${hexToRgba c.on_surface "0.07"};
  #    @define-color card_bg_color ${hexToRgba c.primary "0.05"};
  #    @define-color card_fg_color ${c.on_secondary_container};
  #    @define-color card_shade_color ${hexToRgba c.shadow "0.07"};
  #    @define-color thumbnail_bg_color ${c.secondary_container};
  #    @define-color thumbnail_fg_color ${c.on_secondary_container};
  #    @define-color dialog_bg_color ${c.secondary_container};
  #    @define-color dialog_fg_color ${c.on_secondary_container};
  #    @define-color popover_bg_color ${c.secondary_container};
  #    @define-color popover_fg_color ${c.on_secondary_container};
  #    @define-color shade_color ${hexToRgba c.shadow (if theme.variant == "light" then "0.07" else "0.36")};
  #    @define-color scrollbar_outline_color ${hexToRgba c.outline (if theme.variant == "light" then "1.0" else "0.5")};
  #
  #    @define-color sidebar_bg_color @window_bg_color;
  #    @define-color sidebar_fg_color @window_fg_color;
  #    @define-color sidebar_border_color @window_bg_color;
  #    @define-color sidebar_backdrop_color @window_bg_color;
  #  '';
}
