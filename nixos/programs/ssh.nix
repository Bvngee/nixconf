{ ... }: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    startWhenNeeded = true;
    settings = {
      PermitRootLogin = "no";
      UseDns = false;
      PasswordAuthentication = true; # true is not recommended.
      # below is copied from NotAShelf
      #AuthenticationMethods = "publickey";
      #PubkeyAuthentication = "yes";
      #ChallengeResponseAuthentication = "no";
      #UsePAM = "no";
    };
  };

  programs.ssh = {
    # ...I'd rather you not open up a 1990's x11 window asking for a password
    enableAskPassword = false;

    # TODO: figure out proper ssh key management, esp here
    #knownHosts."latitude".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGneuecw+DQRaHFjvDqRSMogFjBlAAM6uGaAkvpUJWrZ";
  };
}
