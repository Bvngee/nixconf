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
}
