{ config, ... }: {
  home = {
    username = config.profile.mainUser;
    homeDirectory = "/home/${config.profile.mainUser}";
    stateVersion = config.profile.stateVersion;
  };

  # I've heard it's common these fail to build (not sure if necessary anymore)
  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  # Adds the home-manager cli tool to home.packages (for standalone mode).
  # Note: to initialize standalone home-manager for the first time, run
  # something like `nix run home-manager/release-24.05 -- switch --flake .#user@hostname`
  programs.home-manager.enable = true;

  # Some default programs
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    MANPAGER = "nvim +Man\!";
  };

  # This fixes a bug where some HM systemd services have `Requires = [ "tray.target" ];`
  # See https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager Proxy System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
