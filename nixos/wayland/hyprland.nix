{ pkgs, inputs, ... }: {
  # Enable Hyprland's cachix binary cache (must be done first)
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Overrides programs.hyprland package with version from the hyprland flake.
  imports = [ inputs.hyprland.nixosModules.default ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;

    # this field is added by the hyprland flake's nixos module
    plugins = [
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
    ];
  };
  # Install Hyprland's xdg-desktop-portal impl
  xdg.portal = {
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      # we shouldn't need to be this specific
      #"org.freedesktop.impl.portal.Screencast" = "hyprland";
      #"org.freedesktop.impl.portal.Screenshot" = "hyprland";
    };
  };
}
