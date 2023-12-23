{ ... }: {
  programs = {
    gh.enable = true;

    git = {
      enable = true;
      userName = "Jack N";
      userEmail = "nystromjp@gmail.com";
    };
  };
}
