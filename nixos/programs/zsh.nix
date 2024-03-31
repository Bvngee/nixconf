{ ... }: {

  # no idea if all this is even necessary
  programs.zsh = {
    enable = true; # needs to be in system config

    enableCompletion = false; # conflicts with HM zsh plugin "zsh-autocomplete"
  };
  environment.pathsToLink = [ "/share/zsh" ]; # apparently needed for completion of system packages?

}
