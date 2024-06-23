{ config, pkgs, ... }: {

  users.users.${config.profile.mainUser} = {
    isNormalUser = true;
    description = config.profile.mainUserDesc;
    extraGroups = [ "wheel" ]; # "input" "uinput"
    shell = pkgs.zsh;
  };

}
