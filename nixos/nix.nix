{ inputs, lib, pkgs, config, ... }: {
  nix = {
    package = pkgs.nixFlakes;

    # add flake inputs as registrys to make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # add flake inputs to system's legacy channels to make legacy nix- commands consistent too
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ]; # repl-flake allows `nix repl .`
      auto-optimise-store = true;

      # stop warning me that the git tree is dirty, bruh.
      warn-dirty = false;

      # Temporary
      substituters = [ "https://ghostty.cachix.org" ];
      trusted-public-keys = [ "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=" ];
    };
  };
}
