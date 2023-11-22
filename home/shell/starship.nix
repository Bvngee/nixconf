{ lib, config, ... }: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = let 
        color = str: fg: bg: ''[${str}](fg:${fg} bg:${bg})'';
      in lib.concatStrings [ 
        (color " " "0" "4") #  
        ''$directory''
        (color " " "2" "4")
        ''$git_branch$git_status''
        (color "" "2" "3")
        ''$nix_shell''
        (color "" "0" "3")
        " "
      ]; directory = {
        format = ''[$path](bg:4 fg:0)'';
        fish_style_pwd_dir_length = 1;
        truncation_length = 5;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_branch = {
        format = "[( $branch )](bg:2 fg:0)"; #   
      };
      git_status = {
        format = "[($all_status$ahead_behind )](bg:2 fg:0)";
      };
      nix_shell = {
        format = "[( $name )](bg:3 fg:0)";
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
