{ inputs, config, pkgs, ... }: {
  # Adds pkgsUnstable to module args (for both NixOS and HM configs) using
  # inputs.nixpkgs-unstable.
  config = {
    _module.args.pkgsUnstable = import inputs.nixpkgs-unstable ({
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    });
  };
}
