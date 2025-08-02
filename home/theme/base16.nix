{ inputs, pkgs, config, ... }:
let
  base16-schemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "a9112eaae86d9dd8ee6bb9445b664fba2f94037a";
    hash = "sha256-5yIHgDTPjoX/3oDEfLSQ0eJZdFL1SaCfb9d6M0RmOTM=";
  };
in
{
  imports = [
    inputs.base16.homeManagerModule
  ];

  # base16.nix scheme
  scheme = "${base16-schemes}/${config.host.base16Theme}.yaml"; #nord

  home.packages = with config.scheme.withHashtag; let
    printScheme = pkgs.writeShellScriptBin "printScheme" ''
      echo "
        base00 = "${base00}",
        base01 = "${base01}",
        base02 = "${base02}",
        base03 = "${base03}",
        base04 = "${base04}",
        base05 = "${base05}",
        base06 = "${base06}",
        base07 = "${base07}",
        base08 = "${base08}",
        base09 = "${base09}",
        base0A = "${base0A}",
        base0B = "${base0B}",
        base0C = "${base0C}",
        base0D = "${base0D}",
        base0E = "${base0E}",
        base0F = "${base0F}",
      " | nvim
    '';
  in
  [ printScheme ];
}
