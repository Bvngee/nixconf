{ inputs, config, pkgs, ... }: {
  # Enable Hyprland's cachix binary cache (must be done first)
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Overrides programs.hyprland package with version from the hyprland flake.
  imports = [ inputs.hyprland.nixosModules.default ];

  # Hyprland v0.36.0 does not yet have this fix. this ignores the default programs.hyprland.package
  # and makes the cache useless. NOTE: remove this on next release
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland.overrideAttrs
    (_finalAttrs: previousAttrs: {
      patches = previousAttrs.patches ++ [
        ./hyprland-000-fix-tty-switching.txt
      ];
    });

  # Add Hyprland to display manager session list
  services.displayManager.sessionPackages = [
    config.programs.hyprland.package
  ];

  # Install Hyprland's xdg-desktop-portal impl
  xdg.portal = {
    extraPortals = [
      config.programs.hyprland.portalPackage
    ];
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      # we shouldn't need to be this specific
      #"org.freedesktop.impl.portal.Screencast" = "hyprland";
      #"org.freedesktop.impl.portal.Screenshot" = "hyprland";
    };
  };
}
