{ config, ... }: {
  programs = {
    gh.enable = true;
    git = {
      enable = true;
      userName = config.profile.mainUserDesc;
      userEmail = config.profile.mainUserEmail;
      aliases.prettylog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  home.shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gs = "git status";
    gd = "git diff";
    gl = "git prettylog"; # see below, alternative to "git log"
    gp = "git pull";
    gP = "git push";
    grb = "git rebase";
    gm = "git merge";
  };

}
