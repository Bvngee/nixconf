{ config, pkgs, ... }:
let
  cfg = config.services.xserver.windowManager.i3;
in
{
  # see https://github.com/NixOS/nixpkgs/blob/bfb7a882678e518398ce9a31a881538679f6f092/nixos/modules/services/x11/display-managers/default.nix#L282 
  # for how this adds i3 to the display manager
  services.xserver.windowManager.i3 = {
    enable = true;

    # NOTE: none of this is configured at all
    extraPackages = with pkgs; [
      dmenu #application launcher most people use
      i3status # gives you the default i3 status bar
      i3lock #default i3 screen locker
    ];
  };

  environment.systemPackages = [
    cfg.package
  ] ++ cfg.extraPackages;
}
