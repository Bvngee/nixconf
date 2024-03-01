{ pkgs, ... }:
let
  shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gca = "git commit -m";
    gs = "git status";
    gd = "git diff";
    gl = "git log";
    gp = "git pull";
    gr = "git rebase";
    grc = "git rebase --continue";
    gm = "git merge";
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
