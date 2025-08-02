{ lib, config, ... }: {
  programs.sway = {
    enable = true;
    extraOptions = lib.mkIf (config.host.isNvidia) [
      "--unsupported-gpu"
    ];
  };
}
