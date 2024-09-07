{ config, ... }: {
  # Automounting removable media. Depends on NixOS's services.udisk2.enable
  services.udiskie.enable = true;
  services.udiskie.settings = {
    program_options = {
      udisks_version = 2;
      notify = true;
      tray = "auto";
      terminal = "${config.home.sessionVariables.TERMINAL} -d";
    };
  };
}
