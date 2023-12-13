{ ... }: {

  # no idea if all this is even necessary
  programs.zsh.enable = true; # needs to be in system config
  environment.pathsToLink = [ "/share/zsh" ]; # apparently needed for completion of system packages?

}
