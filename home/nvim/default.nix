{ inputs, pkgs, ... }: let
  unstableVimPlugins = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.vimPlugins;
  tabout = pkgs.vimUtils.buildVimPlugin {
    name = "tabout";
    src = pkgs.fetchFromGitHub {
      owner = "abecodes";
      repo = "tabout.nvim";
      rev = "0d275c8d25f32457e67b5c66d6ae43f26a61bce5";
      sha256 = "11zly7bfdz110a7ififylzgizin06ia0i3jipzp12n2n2paarp1f";
    };
  };
  rainbow-delimiters = pkgs.vimUtils.buildVimPlugin {
    name = "rainbow-delimiters";
    src = pkgs.fetchFromGitHub {
      owner = "HiPhish";
      repo = "rainbow-delimiters.nvim";
      rev = "652345bd1aa333f60c9cbb1259f77155786e5514";
      sha256 = "0zw1q7nj76dvvnrb539xc11pymhjbgdjd54m2z64qxbi4n5qwryr";
    };
  };
  persisted = pkgs.vimUtils.buildVimPlugin {
    name = "persisted";
    src = pkgs.fetchFromGitHub {
      owner = "olimorris";
      repo = "persisted.nvim";
      rev = "315cd1a8a501ca8e0c1d55f0c245b9cc0e1ffa01";
      sha256 = "1f1g5dnjv8w5yvvyd7gjp2nim77240jw07kd7af618g8ya7csqf6";
    };
    configurePhase = "rm ./Makefile";
  };
in {
  programs.neovim = {
    enable = true;
    #package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.neovim;
    
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # lsp
      neodev-nvim
      nvim-lspconfig

      # cmp
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-treesitter
      cmp-cmdline
      cmp_luasnip
      lspkind-nvim
      crates-nvim

      # snippets
      luasnip
      friendly-snippets

      # treesitter
      nvim-treesitter.withAllGrammars
      rainbow-delimiters

      # util
      plenary-nvim
      nvim-web-devicons
      popup-nvim
      
      # other
      gruvbox-material
      gitsigns-nvim
      nvim-autopairs
      telescope-nvim
      telescope-zf-native-nvim
      rust-tools-nvim
      lualine-nvim
      nvim-colorizer-lua
      tabout
      unstableVimPlugins.indent-blankline-nvim
      # neoscroll-nvim
      nvim-navic #currently unused
      persisted
      guess-indent-nvim

      # mini.ai|comment|cursorword|moves|surround
      mini-nvim
    ];

    extraPackages = with pkgs; [ gcc ripgrep fd nil lua-language-server stylua ];

    extraLuaConfig = builtins.concatStringsSep "\n" ((map builtins.readFile [
      ./config/options.lua
      ./config/keybindinds.lua

      ./config/plugins/nvim-treesitter.lua
      ./config/plugins/telescope-nvim.lua
      ./config/plugins/nvim-colorizer.lua
      ./config/plugins/tabout.lua
      ./config/plugins/gitsigns.lua
      ./config/plugins/lualine.lua
      ./config/plugins/indent-blankline-nvim.lua
      ./config/plugins/rainbow-delimiters.lua
      # ./config/plugins/neoscroll.lua
      ./config/plugins/nvim-navic.lua
      ./config/plugins/persisted.lua

      ./config/plugins/mini-ai.lua
      ./config/plugins/mini-comment.lua
      ./config/plugins/mini-move.lua
      ./config/plugins/mini-surround.lua

      ./config/lsp/neodev.lua
      ./config/lsp/lspconfig.lua
      ./config/lsp/nvim-cmp.lua
    ]) ++ [
      ''require('mini.cursorword').setup {}''
      ''require('nvim-autopairs').setup {}''
      ''require('guess-indent').setup {}''
      ''require('crates').setup { src = { cmp = { enabled = true } } }''
    ]);

  };
}

# gruvbox-material colors derived from: DARK, MEDIUM (bg)
# \ 'bg0':              ['#282828',   '235'],
# \ 'bg1':              ['#32302f',   '236'],
# \ 'bg2':              ['#32302f',   '236'],
# \ 'bg3':              ['#45403d',   '237'],
# \ 'bg4':              ['#45403d',   '237'],
# \ 'bg5':              ['#5a524c',   '239'],
# \ 'bg_statusline1':   ['#32302f',   '236'],
# \ 'bg_statusline2':   ['#3a3735',   '236'],
# \ 'bg_statusline3':   ['#504945',   '240'],
# \ 'bg_diff_green':    ['#34381b',   '22'],
# \ 'bg_visual_green':  ['#3b4439',   '22'],
# \ 'bg_diff_red':      ['#402120',   '52'],
# \ 'bg_visual_red':    ['#4c3432',   '52'],
# \ 'bg_diff_blue':     ['#0e363e',   '17'],
# \ 'bg_visual_blue':   ['#374141',   '17'],
# \ 'bg_visual_yellow': ['#4f422e',   '94'],
# \ 'bg_current_word':  ['#3c3836',   '237']
#
# +MATERIAL (fg) colors
# \ 'fg0':              ['#d4be98',   '223'],
# \ 'fg1':              ['#ddc7a1',   '223'],
# \ 'red':              ['#ea6962',   '167'],
# \ 'orange':           ['#e78a4e',   '208'],
# \ 'yellow':           ['#d8a657',   '214'],
# \ 'green':            ['#a9b665',   '142'],
# \ 'aqua':             ['#89b482',   '108'],
# \ 'blue':             ['#7daea3',   '109'],
# \ 'purple':           ['#d3869b',   '175'],
# \ 'bg_red':           ['#ea6962',   '167'],
# \ 'bg_green':         ['#a9b665',   '142'],
# \ 'bg_yellow':        ['#d8a657',   '214']
