{ ... }: {
  profile = {
    hostname = "pc";
    stateVersion = "23.05";
    mainUser = "jack";
    mainUserDesc = "Jack N";
    mainUserEmail = "nystromjp@gmail.com";
    flakeRoot = "/home/jack/dev/nixconf";
    isMobile = false;
    isNvidia = true;
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
    theme = {
      variant = "dark";
      base16Theme = "gruvbox-material-dark-medium";
    };
  };
}
