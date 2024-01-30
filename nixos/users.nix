{ pkgs, ... }: {

  users.users.jack = {
    isNormalUser = true;
    description = "Jack N";
    extraGroups = [ "wheel" ]; # "input" "uinput"
    shell = pkgs.zsh;
  };

}
