{ config, ... }: {
  # Automounting removable media. Frontend for udisk2
  # Maybe try autofs instead at some point?
  services.udiskie.enable = true;
  services.udiskie.settings = {
    program_options = {
      udisks_version = 2;
      automount = true;
      tray = false; # "auto"
      terminal = "${config.home.sessionVariables.TERMINAL} -d";
      notify = true;
    };
    notifications = {
      timeout = 3; # default for all notifs
      device_added = false;
    };
  };
}
