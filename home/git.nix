{ ... }:
let
  shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
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
  programs = {
    gh.enable = true;

    git = {
      enable = true;
      userName = "Jack N";
      userEmail = "nystromjp@gmail.com";
    };

    zsh.shellAliases = shellAliases;
    bash.shellAliases = shellAliases;
  };
}
