{ ... }: {
  profile = {
    hostname = "wsl";
    stateVersion = "24.05";
    mainUser = "jacknystrom";
    mainUserDesc = "Jack N";
    mainUserEmail = "nystromjp@gmail.com";
    flakeRoot = "/home/jacknystrom/dev/nixconf";
    isMobile = true;
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
    theme = {
      variant = "dark";
      base16Theme = "gruvbox-material-dark-medium";
    };
  };
}
