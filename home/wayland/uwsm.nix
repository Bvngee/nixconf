{ lib, config, ... }: {
  # For Hyprland-specific HYPR* and AQ* variables only.
  xdg.configFile."uwsm/env-hyprland".text = lib.concatStringsSep "\n\n"
    [
      # For precision laptop, tell hyprland to use the integrated gpu first
      (lib.optionalString
        (config.profile.hostname == "precision")
        ''export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0"'')

      ''
        # Fixed a hyprland-specific issue with seatd; not sure if still needed
        LIBSEAT_BACKEND=logind
      ''
    ];

  # For all theming, xcursor, nvidia and toolkit variables.
  xdg.configFile."uwsm/env".text = lib.concatStringsSep "\n\n" [
    (lib.optionalString (config.profile.isNvidia) ''
      # Force usage of GBM over EGLStreams (the specific buffer API that the gpu
      # driver and wayland compositor communicate with).
      GBM_BACKEND=nvidia-drm
      __GLX_VENDOR_LIBRARY_NAME=nvidia

      # Hardware acceleration on Nvidia GPUs
      LIBVA_DRIVER_NAME=nvidia

      # Tell the nvidia-vaapi-driver to use the direct backend instead of egl.
      NVD_BACKEND=direct

      # G-Sync / Variable Refresh Rate (VRR) settings. See
      # https://wiki.hypr.land/Configuring/Environment-variables/#nvidia-specific
      __GL_GSYNC_ALLOWED=1
      __GL_VRR_ALLOWED=0
    '')

    ''
      # Toolkit environment variables
      GDK_BACKEND=wayland,x11
      QT_QPA_PLATFORM=wayland;xcb
      QT_AUTO_SCREEN_SCALE_FACTOR=1
      QT_WAYLAND_DISABLE_WINDOWDECORATION=1 # do I want this?
      _JAVA_AWT_WM_NONEREPARENTING=1
      SLD_VIDEODRIVER=wayland
      CLUTTER_BACKEND=wayland

      # Nixpkgs adds ozone (chromium) wayland flags to a bunch of apps if this
      # env var is set.
      NIXOS_OZONE_WL=1
    ''
  ];
}
