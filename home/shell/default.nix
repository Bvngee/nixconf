{ ... }: {
  imports = [
    ./zsh.nix
    ./starship.nix
  ];

  home.shellAliases = {
    # regular ls,ll,la etc aliases are handled by eza's settings
    tree = "eza --icons --group-directories-first --tree";

    # z/zi is defined by zoxide
    cd = "z";
    cdi = "zi";

    lsa = "ls -a";

    # useful for nix store paths. Calls realpath on the result of which
    rpwhich = "f() { realpath $(which \"$1\") }; f";

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
    y = "yazi";
    yy = "yazi";

    c = "calc -d --";
  };

  home.sessionVariables = {
    # this is supposed to make colors and eg. mouse inputs work, tbh though idk
    # if it does anything
    LESS = "-RF";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # GNU readline library used by many repls (eg. python, gdb)
  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    # Do I want this? It's kinda cool but feels a little hacky/weird
    extraConfig = ''
      set editing-mode vi
    '';
  };

  # home/cli.nix has lots more program configurations related to the shell!

}
