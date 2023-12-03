{ pkgs, config, pkgsUnstable, ... }: let
  unstableVimPlugins = pkgsUnstable.vimPlugins;
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
    
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # lsp
      neodev-nvim
      nvim-lspconfig

      # formatting
      unstableVimPlugins.conform-nvim

      # linting
      #nvim-lint - setup later?
      #eg. use for eslint, clang-tidy, and more?

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
      unstableVimPlugins.crates-nvim

      # snippets
      luasnip
      friendly-snippets

      # treesitter
      nvim-treesitter.withAllGrammars
      unstableVimPlugins.rainbow-delimiters-nvim

      # util
      plenary-nvim
      nvim-web-devicons
      popup-nvim
      
      # other
      gruvbox-material
      nvim-base16 #alternatives: Iron-E/nvim-highlite, ThemerCorp/themer.lua
      gitsigns-nvim
      nvim-autopairs
      telescope-nvim
      telescope-zf-native-nvim
      rust-tools-nvim
      lualine-nvim
      nvim-colorizer-lua
      unstableVimPlugins.tabout-nvim
      unstableVimPlugins.indent-blankline-nvim
      nvim-navic #currently unused
      persisted
      guess-indent-nvim

      # mini.[ai|comment|cursorword|moves|surround]
      mini-nvim
    ];

    extraPackages = with pkgs; [ gcc ripgrep fd nil lua-language-server stylua ];

    extraLuaConfig = let
      addLuaFile = file: ''
        do -- ${toString file}
        ${builtins.readFile file}
        end
      '';
    in 
      ( # base16.nix nvim integration using nvim-base16 plugin
        import ./config/plugins/nvim-base16.nix { inherit (config) scheme; }
      ) +
      builtins.concatStringsSep "\n" (map addLuaFile [
        ./config/plugins/nvim-base16.lua

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
        ./config/plugins/nvim-navic.lua
        ./config/plugins/persisted.lua
        ./config/plugins/conform-nvim.lua

        ./config/plugins/mini-ai.lua
        ./config/plugins/mini-comment.lua
        ./config/plugins/mini-move.lua
        ./config/plugins/mini-surround.lua

        ./config/lsp/neodev.lua
        ./config/lsp/lspconfig.lua
        ./config/lsp/nvim-cmp.lua
      ]) + ''

        require('mini.cursorword').setup {}
        require('nvim-autopairs').setup {}
        require('guess-indent').setup {}
        require('crates').setup { src = { cmp = { enabled = true } } }
        require('luasnip.loaders.from_vscode').lazy_load()

      '';
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
