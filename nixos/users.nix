{ config, pkgs, ... }: {

  users.users.${config.host.mainUser} = {
    isNormalUser = true;
    description = config.host.mainUserDesc;
    extraGroups = [ "wheel" ]; # "input" "uinput"
    shell = pkgs.zsh;
  };

}
