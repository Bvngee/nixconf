{ pkgs, ... }: {
  systemd.user.services.kdeconnect = {
    Unit.Description = "KDEConnect Service";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.plasma5Packages.kdeconnect-kde}/bin/kdeconnect-indicator";
      TimeoutStopSec = 5;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
