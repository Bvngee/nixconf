## NOTE: This also enables Yazi, an alternative terminal file manager I might switch to
{ pkgsUnstable, ... }: {
  home.packages = [
    pkgsUnstable.yazi
    pkgsUnstable.joshuto
  ];

  xdg.configFile."joshuto/preview_file.sh".source = ./preview_file.sh;

  programs.zsh.shellAliases = {
    js = "joshuto";
    yy = "yazi";
  };
}
