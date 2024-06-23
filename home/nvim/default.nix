{ config, pkgs, ... }: {
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.profile.flakeRoot}/home/nvim/config";

  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withRuby = false;
    withPython3 = false;
    withNodeJs = false;

    extraPackages = with pkgs; [
      gnumake
      gcc
      ripgrep
      fd
    ];
  };
}
