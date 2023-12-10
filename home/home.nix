{ ... }: {
  home = {
    # TODO: set these depending on user variable?
    username = "jack";
    homeDirectory = "/home/jack";
    stateVersion = "23.05"; # Please read the comments before changing this value.  
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  # Let Home Manager install and manage itself for standalone mode.
  programs.home-manager.enable = false; # currently installed via environment.systemPackages
}
