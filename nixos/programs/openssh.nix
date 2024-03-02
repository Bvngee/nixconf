{ ... }: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false; # true is not recommended.
      # below is copied from NotAShelf
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
      UsePAM = "no";
    };
  };

  programs.ssh = {
    # ...I'd rather you not open up a 1990's x11 window asking for a password
    enableAskPassword = false;
  };
}
