{ lib, isNvidia, ... }: {
  programs.sway = {
    enable = true;
    extraOptions = lib.mkIf (isNvidia) [
      "--unsupported-gpu"
    ];
  };
}
