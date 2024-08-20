{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
    # See defaults here: https://github.com/NixOS/nixpkgs/blob/5bb0c5ac60d5dc25c08ce3910ff75ea1da0e4026/nixos/modules/programs/nix-ld.nix#L44-L59
    libraries = [ ];
  };
}
