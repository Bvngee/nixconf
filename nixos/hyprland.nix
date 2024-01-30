{ config, inputs, ... }: {
  # Overrides Hyprland packages with versions from the hyprland flake.
  imports = [ inputs.hyprland.nixosModules.default ];

  # Add Hyprland to display manager session list
  services.xserver.displayManager.sessionPackages = [
    config.programs.hyprland.finalPackage
  ];

  # Install Hyprland's xdg-desktop-portal
  xdg.portal = {
    extraPortals = [
      config.programs.hyprland.portalPackage
    ];
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
    };
  };

  # Enable Hyprland's cachix binary cache
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
