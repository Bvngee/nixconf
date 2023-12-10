{ config, ... }: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["gwenview.desktop"];
      };
    };

    # Hopefully this fixes the constant override warnings?
    configFile."mimeapps.list".force = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
