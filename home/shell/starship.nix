{ lib, config, ... }: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [ 
        "[](fg:4)" #  
        ''$directory''
        "[](fg:6 bg:4)"
        ''$git_branch$git_status''
        "[](fg:2 bg:6)"
        ''$nix_shell''
        "[](fg:2)"
        " "
      ]; directory = {
        format = ''[ $path ](bg:4 fg:0)'';
        fish_style_pwd_dir_length = 1;
        truncation_length = 5;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_branch = {
        format = "[( $branch )](bg:6 fg:0)"; #   
      };
      git_status = {
        format = "[($all_status$ahead_behind )](bg:6 fg:0)";
      };
      nix_shell = {
        format = "[( $name )](bg:2 fg:0)";
      };
    };
  };
}

/*
        (toGray ''\['') #   󰉋  󰉋  
        ''$directory''
        #(toGray ''\]'')
        ''(''
        #(toGray ''\('') #   󰊢 󰊢    
        #(toGray " 󰧞 ")
        " "
        ''$git_branch$git_status''
        #(toGray ''\)'')
        '')''
        ''(''
        #(toGray ''<'') #  ❄️ 
        #(toGray " 󰧞 ")
        " "
        ''$nix_shell''
        #(toGray ''>'')
        '')''
        (toGray ''\]'')
        ''$character ''
*/
