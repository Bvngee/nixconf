{ ... }: let
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
in {
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
