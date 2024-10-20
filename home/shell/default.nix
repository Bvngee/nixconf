{ ... }: {
  imports = [
    ./zsh.nix
    ./starship.nix
  ];

  programs = {
    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [ "--group-directories-first" ];
      icons = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
    };
  };

  home.shellAliases = {
    # regular ls,ll,la etc aliases are handled by eza's settings
    tree = "eza --icons --group-directories-first --tree";

    # z/zi is defined by zoxide
    cd = "z";
    cdi = "zi";

    # a little overkill but hey why not
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";

    # best fetch so far
    fetch = "fastfetch --structure Title:Separator:OS:Host:Kernel:Uptime:Packages:Shell:Display:DE:WM:WMTheme:Theme:Icons:Font:Cursor:Terminal:TerminalFont:CPU:GPU:Break:Colors";

    # not sure which one I like yet (if any)
    js = "joshuto";
    yy = "yazi";
  };

}
