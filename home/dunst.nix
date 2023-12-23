{ config, ... }: let
  scheme = config.scheme.withHashtag;
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "none";
        monitor = 0;
        layer = "overlay";
        origin = "top-center";
        alignment = "center";
        corner_radius = 7;
        font = "Roboto 12";
        format = ''<span size="x-small" weight="light">%a</span>\n<b>%s</b>\n%b'';
        frame_width = 0;
        offset = "0x20";
        horizontal_padding = 10;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 64;
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
        show_indicators = false;
        shrink = "no";
        word_wrap = "yes";
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";

        background = scheme.base01;
        foreground = scheme.base05;
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_low = {
        timeout = 2;
      };
      urgency_normal = {
        timeout = 4;
      };
      urgency_critical = {
        timeout = 6;
      };
    };
  };
}
