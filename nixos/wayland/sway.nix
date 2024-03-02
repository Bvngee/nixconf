{ lib, config, ... }: let
  isNvidia = config.hardware.nvidia != null;
in {
  programs.sway = {
    enable = true;
    extraOptions = lib.mkIf (isNvidia) [
      "--unsupported-gpu"
    ];
  };
}
