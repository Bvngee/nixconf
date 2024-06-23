{ config, lib, ... }: {
  # Not sure if I need this? It's already enabled anyways so shouldn't make a difference ¯\_(ツ)_/¯
  services.libinput.enable = true;

  # For stationary devices (on which I will likely do some gaming), allow
  # mice to click fast. TODO: make the condition more sensible than !isMobile
  environment.etc."libinput/local-overrides.quirks" = lib.mkIf (!config.profile.isMobile) {
    text = ''
      [Disable Mouse Debounce Protection]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';
  };
}
