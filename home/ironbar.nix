{ pkgs, ... }: {
  home.packages = [ pkgs.ironbar ];

  home.file.".config/ironbar/config.json".text = builtins.toJSON {
    position = "top";
    height = 22;
    popup_gap = 20;
    start = [
      {
        type = "clock";
        format = "%b %e  %l:%M%P";
      }
      {
        type = "music";
        player_type = "mpris";
        truncate = "end";
        format = "{title}";
        icon_size = 16;
        show_status_icon = false;
      }
    ];
    center = [
      {
        type = "workspaces";
      }
    ];
    end = [
      {
        type = "tray";
      }
      {
        type = "upower";
      }
      {
        type = "custom";
        class = "power-menu";
        bar = [
          {
            type = "button";
            label = "Butt";
            on_click = "!notify-send 'Hi'";
          }
        ];
      }
    ];
  };
  home.file.".config/ironbar/style.css".text = ''
    
  '';
}
