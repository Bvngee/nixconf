{ ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # true is not recommended.
    };
  };
}
