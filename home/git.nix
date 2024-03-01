{ pkgs, ... }:
let
  shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gs = "git status";
    gl = "git log";
    gr = "git rebase";
    grc = "git rebase --continue";
    gm = "git merge";
    gc = "git commit";
    gp = "git pull";
  };
in
{
  home.packages = [ pkgs.gh ];

  programs = {
    # Annoying, as it semi-breaks `gh auth *` commands
    #gh.enable = true;

    git = {
      enable = true;
      userName = "Jack N";
      userEmail = "nystromjp@gmail.com";
    };

    zsh.shellAliases = shellAliases;
    bash.shellAliases = shellAliases;
  };
}
