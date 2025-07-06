{ ... }: {
  # Enable hyprland. Plugins are added via the home manager module.
  programs.hyprland = {
    enable = true;
    # See https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm for
    # warnings and recommendations. This option sets
    # `programs.uwsm.waylandCompositors.hyprland.*` for us
    withUWSM = true;
  };
  xdg.portal = {
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      # we shouldn't need to be this specific
      #"org.freedesktop.impl.portal.Screencast" = "hyprland";
      #"org.freedesktop.impl.portal.Screenshot" = "hyprland";
    };
  };
}
