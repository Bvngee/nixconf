{ lib, config, ... }: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = let 
        toGray = color: ''[${color}](fg:bright-black)'';
      in lib.concatStrings [ 
        (toGray ''\['') #   󰉋  󰉋   
        ''$directory''
        (toGray ''\]'')
        ''(''
        (toGray ''\('') #   󰊢 󰊢    
        ''$git_branch$git_status''
        (toGray ''\)'')
        '')''
        ''(''
        (toGray ''<'') #  ❄️ 
        ''$nix_shell''
        (toGray ''>'')
        '')''
        " "
      ];
      directory = {
        format = ''[$path](fg:blue)'';
        fish_style_pwd_dir_length = 1;
        truncation_length = 5;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_branch = {
        format = "[($branch)](fg:green)"; #   
      };
      git_status = {
        format = "[( $all_status$ahead_behind)](fg:green)";
      };
      nix_shell = {
        format = "[$name](fg:purple)";
      };
    };
  };
}
