{ ... }: {
  # UWSM wraps standalone compositors as a set of systemd services.
  programs.uwsm.enable = true;

  # For ~/.config/uwsm/[env,env_xx] configuration files, see home/wayland/uwsm.nix.

  # For `programs.uwsm.waylandCompositors` configurations, see
  # nixos/hyprland.nix, nixos/sway.nix, etc.
}
