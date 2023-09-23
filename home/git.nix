{ pkgs, ... }: {
  programs = {
    gh.enable = true;

    git = {
      enable = true;
      userName = "Jack Nystrom";
      userEmail = "nystromjp@gmail.com";
    };
  };
}
