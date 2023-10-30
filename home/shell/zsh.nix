{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh_history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    shellAliases = {
      # regular ls,ll,la etc aliases are handled by eza's settings
      tree = "eza --icons --group-directories-first --tree";
    };
    initExtraFirst = ''
      # automatically called by zsh-vi-mode plugin
      function zvm_config() {
        ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX # required for below
        ZVM_ESCAPE_KEYTIMEOUT=0.001
        ZVM_VI_SURROUND_BINDKEY=s-prefix

        # no clue whatsoever how this works, but it makes visual mode look ok
        ZVM_VI_HIGHLIGHT_BACKGROUND="white" #\033[
        ZVM_VI_HIGHLIGHT_FOREGROUND="\033["
      }
    '';
    initExtra = ''
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
    '';

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    defaultKeymap = "viins";

    plugins = [
      # HM/zsh.nix's module for this plugin sources too late
      # to add the bindings, which must be added manually as
      # there's no way to add vim mode bindings via the module.
      {
        name = "zsh-history-substring-search";
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
        src = pkgs.zsh-history-substring-search;
      }
      {
        name = "zsh-vi-mode";
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        src = pkgs.zsh-vi-mode;
      }
      {
        name = "zsh-autopair";
        file = "share/zsh/zsh-autopair/autopair.zsh";
        src = pkgs.zsh-autopair;
      }
    ];
  };
}
