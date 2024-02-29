{ ... }: {

  imports = [
    ./zsh.nix
    ./starship.nix
  ];

  programs = {
    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [ "--group-directories-first" ];
      icons = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };

}
