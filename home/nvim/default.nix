{ inputs, config, pkgs, ... }: {
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.host.flakeRoot}/home/nvim/config";

  home.packages = [
    # Extremely temporary; pending config rewrite!
    inputs.nixpkgs-neovim.legacyPackages.${pkgs.system}.neovim
  ];

  programs.neovim = {
    enable = false;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withRuby = false;
    withPython3 = false;
    withNodeJs = false;

    extraPackages = with pkgs; [
      stdenv.cc
      gnumake
      ripgrep
      fd
    ];
  };
}
