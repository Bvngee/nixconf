{ user, ... }: {
  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  # Let Home Manager install and manage itself for standalone mode.
  programs.home-manager.enable = false; # currently installed via environment.systemPackages

  home.sessionVariables = {
    GOPATH = "/home/${user}/.local/share/go";
    GOMODCACHE = "/home/${user}/.cache/go/pkg/mod";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };
}
