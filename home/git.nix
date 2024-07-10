{ config, ... }: {
  programs = {
    gh.enable = true;
    git = {
      enable = true;
      userName = config.profile.mainUserDesc;
      userEmail = config.profile.mainUserEmail;
      aliases.prettylog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

      extraConfig = {
        init.defaultBranch = "main";
        core.askPass = ""; # disabled ridiculous ssh gui password prompt
        # not sure exactly what these do, copied from NotAShelf
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };

      delta = {
        # sets git's core.pager and interactive.diffFilter
        enable = true;
        options = {
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
            hunk-decoration-style = "bold blue ul";
            hunk-header-style = "omit";
          };
          line-numbers = {
            line-numbers = true;
            line-numbers-minus-style = "brightblack";
            line-numbers-zero-style = "brightblack";
            line-numbers-plus-style = "brightblack";
            line-numbers-left-format = ""; # {nm:>4}┊
            line-numbers-left-style = ""; # brightblack
            line-numbers-right-format = "{np:>4}│";
            line-numbers-right-style = "brightblack";
          };
          features = "decorations line-numbers";
          whitespace-error-style = "22 reverse";
          navigate = true;
          hyprlinks = true;
          syntax-theme = "none";
        };
      };
    };
  };

  # enable scrolling in delta's git diff
  home.sessionVariables.DELTA_PAGER = "less -RF";

  home.shellAliases = {
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gs = "git status";
    gd = "git diff";
    gds = "git diff --staged";
    gl = "git prettylog"; # see below, alternative to "git log"
    gp = "git pull";
    gP = "git push";
    gPf = "git push --force";
    grb = "git rebase";
    gm = "git merge";
  };

}
