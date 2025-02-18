{ ... }: {
  # Not sure if I need this? It's already enabled anyways so shouldn't make a difference ¯\_(ツ)_/¯
  services.libinput.enable = true;

  # Allow mice to click fast
  environment.etc."libinput/local-overrides.quirks" = {
    text = ''
      [Disable Mouse Debounce Protection]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';
  };
}
