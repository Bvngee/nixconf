{ ... }: {
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Medium";
    settings = {
      font = "CaskaydiaCove NF SemiBold";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
    };
  };
}
