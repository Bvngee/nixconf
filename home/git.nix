{ ... }: let
  shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gca = "git commit --amend";
    gr = "git rebase";
    grc = "git rebase --continue";
    gm = "git merge";
    gp = "git pull";
    gs = "git status";
    gl = "git log";
    gd = "git diff";
  };
in {
  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      gitCredentialHelper.hosts = [
        "https://github.com"
      ];
    };

    git = {
      enable = true;
      userName = "Jack N";
      userEmail = "nystromjp@gmail.com";
    };

    zsh.shellAliases = shellAliases;
    bash.shellAliases = shellAliases;
  };
}
