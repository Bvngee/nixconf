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
