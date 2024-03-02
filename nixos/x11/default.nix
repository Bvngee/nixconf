# X11 stuff is enabled mostly for testing and as a last-resort backup.
{ config, pkgs, ... }: {
  imports = [
    ./i3.nix
  ];

  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;

    displayManager.startx.enable = true;

  };

}
