{ pkgsUnstable, ... }: {
  # Enable hyprland. Plugins are added via the home manager module.
  programs.hyprland = {
    enable = true;
    # TODO: UPDATE TO pkgsUnstable HYPRLAND (0.51.1) ASAP (for the config reloading modifiers bugfix)
    # ^ Waiting on hyprlandPlugins.hyprsplit nixpkgs PR!
    # package = pkgsUnstable.hyprland;
    # portalPackage = pkgsUnstable.xdg-desktop-portal-hyprland;

    # I prefer not having a python wrapper around my compositors. I use the
    # basic sytemd target from the Hyprland HM module instead
    withUWSM = false;
  };
  xdg.portal = {
    config.hyprland = {
      # Note: hyprland.enable doesthis already. Kept for explicitness sake
      default = [ "hyprland" "gtk" ];
    };
  };
}
