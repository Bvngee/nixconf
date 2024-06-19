{ config, lib, pkgs, ... }:
let
  cfg = config.programs.zsh;
  relToDotDir = file: (lib.optionalString (cfg.dotDir != null) (cfg.dotDir + "/")) + file;
in
{
  home.packages = with pkgs; [
    trash-cli
  ];

  ## How to Fix "zsh: corrupt history file"
  # mv ~/.local/share/zsh_history ~/.local/share/zsh_history_bad
  # strings ~/.local/share/zsh_history_bad > ~/.local/share/zsh_history
  # fc -R ~/.local/share/zsh_history 
  # rm ~/.local/share/zsh_history_bad  

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

      # z/zi is defined by zoxide
      cd = "z";
      cdi = "zi";

      # best fetch so far
      fetch = "fastfetch";

      # not sure which one I like yet (if any)
      js = "joshuto";
      yy = "yazi";
    };
    initExtraFirst = ''
      # automatically called by zsh-vi-mode plugin
      function zvm_config() {
        ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX # required for below
        ZVM_ESCAPE_KEYTIMEOUT=0.001
        ZVM_VI_SURROUND_BINDKEY=s-prefix
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

        # no clue whatsoever how this works, but it makes visual mode look ok
        ZVM_VI_HIGHLIGHT_BACKGROUND="white" #\033[
        ZVM_VI_HIGHLIGHT_FOREGROUND="\033["
      }

      # set normal/visual mode keybindings here, as they might conflict with zsh-vi-mode
      function zvm_after_lazy_keybindings() {
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      }

      function zvm_after_init() {
        # needs to be here to work around zsh-vi-mode
        bindkey '^ ' autosuggest-accept
        bindkey '^y' autosuggest-accept
      }

      # if ZSH_PROFILE is set, do profiling
      if [ "$ZSH_PROFILE" -eq 1 ]; then
        zmodload zsh/zprof
      fi
    '';
    initExtra = ''
      function flakify() {
        if [ ! -e flake.nix ]; then
          git clone https://raw.githubusercontent.com/BvngeeCord/nix-flake-template/blob/main/flake.nix
          echo "Copied flake.nix template!"
        fi
        if [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
          echo "Create and enabled .envrc!"
        fi
        # $${EDITOR:-vim} flake.nix
      }

      export PATH="$PATH:$HOME/.local/bin"

      # stolen from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/fancy-ctrl-z
      fancy-ctrl-z () {
        if [[ $#BUFFER -eq 0 ]]; then
          BUFFER="fg"
          zle accept-line -w
        else
          zle push-input -w
          zle clear-screen -w
        fi
      }
      zle -N fancy-ctrl-z
      bindkey '^Z' fancy-ctrl-z
    '';

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    defaultKeymap = "viins";

    plugins = [
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
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.zsh-nix-shell;
      }
      # too complex, doesn't integrate well with other plugins, seems hard to configure
      # note: requires `enableCompletion = true;` # from future: did I mean "= false" there? I forget lol
      # {
      #   name = "zsh-autocomplete";
      #   file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      #   src = pkgs.zsh-autocomplete;
      # }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ ];
  };

  # Unfortunately, there is currently no way to add anything to .zshrc after the lines
  # that get added by enableSyntaxHighlighting and historySubstringSearch.enable through
  # Home Manager's zsh.nix module (which is necessary to configure them). This does what
  # would be accomplished by the addition of something like "initExtraLast".
  home.file."${relToDotDir ".zshrc"}".text = ''
    # zsh-syntax-highlighting configuration
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main) # add future additional highlighters here
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red' # remove bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan' # cyan string color.
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan' # does this work with
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=cyan' # all color schemes?
    ZSH_HIGHLIGHT_STYLES[path]=none # remove annoying underlines (?)
    ZSH_HIGHLIGHT_STYLES[path_prefix]=none

    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='underline,bold'

    if [ "$ZSH_PROFILE" -eq 1 ]; then
      zprof
    fi
  '';
}
