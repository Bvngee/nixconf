{ lib, config, ... }: {
  programs.sway = {
    enable = true;
    extraOptions = lib.mkIf (config.profile.isNvidia) [
      "--unsupported-gpu"
    ];
  };
}
