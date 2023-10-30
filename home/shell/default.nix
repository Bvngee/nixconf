{ inputs, pkgs, ... }: {

  imports = [
    ./zsh.nix
    ./starship.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    exa = {
      enable = true;
      enableAliases = true;
      extraOptions = [ "--group-directories-first" ];
      icons = true;
      package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.eza;
    };
  };

}
