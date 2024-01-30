{ config, ... }: {
  xdg = {
    enable = true;
    mimeApps = rec {
      enable = true;
      associations.added = defaultApplications;
      defaultApplications = let
        browser = ["firefox.desktop"];
      in {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/element" = [ "element-desktop.desktop" ];
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-extension-xht" = browser;
        "application/json" = browser;

        "application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];

        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["gwenview.desktop"]; # imv.desktop?

        "inode/directory" = ["thunar.desktop"];
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
