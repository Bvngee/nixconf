{ lib, config, ... }: {
  # Wrap Sway with UWSM (same as programs.hyprland.withUWSM)
  programs.uwsm.waylandCompositors = {
    sway = {
      prettyName = "Sway";
      comment = "Sway compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/sway";
    };
  };

  programs.sway = {
    enable = true;
    extraOptions = lib.mkIf (config.profile.isNvidia) [
      "--unsupported-gpu"
    ];
  };
}
