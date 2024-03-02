# X11 stuff is enabled mostly for testing and as a last-resort backup.
{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;

    displayManager.startx.enable = true;

    windowManager.i3 = {
      enable = true;
      # NOTE: none of this is configured at all
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
     ];
    };
  };
}
