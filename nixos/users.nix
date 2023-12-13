{ pkgs, ... }: {

  users.users.jack = {
    isNormalUser = true;
    description = "Jack N";
    extraGroups = [ "wheel" "networkmanager" ]; # "input" "uinput"
    shell = pkgs.zsh;
  };

}
