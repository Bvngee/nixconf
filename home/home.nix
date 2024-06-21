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

  # Adds the home-manager cli tool to home.packages (for standalone mode)
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };
}
