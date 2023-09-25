{ ... }: {

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # does this need to be here?
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs = {
    kdeconnect.enable = true;

    zsh.enable = true;
  };
}
