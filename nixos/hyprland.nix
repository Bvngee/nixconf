{ inputs, config, ... }: {
  # Enable Hyprland's cachix binary cache (must be done first)
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Overrides Hyprland packages with versions from the hyprland flake.
  imports = [ inputs.hyprland.nixosModules.default ];

  # Add Hyprland to display manager session list
  services.xserver.displayManager.sessionPackages = [
    config.programs.hyprland.package
  ];

  # Install Hyprland's xdg-desktop-portal
  xdg.portal = {
    extraPortals = [
      config.programs.hyprland.portalPackage
    ];
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      #"org.freedesktop.impl.portal.Screencast" = "hyprland"; # we shouldn't need to be this specific
      #"org.freedesktop.impl.portal.Screenshot" = "hyprland";
    };
  };
}
