{ inputs, pkgs, ... }: {
  systemd.user.services.kdeconnect = {
    Unit.Description = "KDEConnect Service";
    Service = {
      Type = "simple";
      ExecStart = "${inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.kdeconnect}/bin/kdeconnect-indicator";
      TimeoutStopSec = 5;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
