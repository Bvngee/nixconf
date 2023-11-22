{ config, ... }: {
  programs.kitty = with config.scheme.withHashtag; {
    enable = true;
    #theme = "Gruvbox Material Dark Medium";
    settings = {
      font = "CaskaydiaCove NF SemiBold";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";

      # base16.nix colorscheme - based on github:kdrag0n/base16-kitty default-256 template
      background = base00;
      foreground = base05;
      selection_background = base05;
      selection_foreground = base00;
      url_color = base04;
      cursor = base05;
      active_border_color = base03;
      inactive_border_color = base01;
      active_tab_background = base00;
      active_tab_foreground = base05;
      inactive_tab_background = base01;
      inactive_tab_foreground = base04;
      tab_bar_background = base01;

      color0 = base00;
      color1 = base08;
      color2 = base0B;
      color3 = base0A;
      color4 = base0D;
      color5 = base0E;
      color6 = base0C;
      color7 = base05;
      
      color8 = base03; # bright
      color9 = base08;
      color10 = base0B;
      color11 = base0A;
      color12 = base0D;
      color13 = base0E;
      color14 = base0C;
      color15 = base07;

      color16 = base09; # extended base16 colors
      color17 = base0F;
      color18 = base01;
      color19 = base02;
      color20 = base04;
      color21 = base06;    
    };
  };
}
