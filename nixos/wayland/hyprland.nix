{ ... }: {
  # Enable hyprland. Plugins are added via the home manager module.
  programs.hyprland = {
    enable = true;

    # I prefer not having a python wrapper around my compositors. I use the
    # basic sytemd target from the Hyprland HM module instead
    withUWSM = false;
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
