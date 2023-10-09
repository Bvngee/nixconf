{ inputs, pkgs, ... }: let
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

      # snippets
      luasnip
      friendly-snippets

      # treesitter
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      #nvim-treesitter-textobjects - mini.ai instead
      #nvim-ts-rainbow2 - rainbow-delimiters instead
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
      #telescope-file-browser-nvim
      rust-tools-nvim
      lualine-nvim
      nvim-colorizer-lua
      tabout
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.vimPlugins.indent-blankline-nvim
      neoscroll-nvim
      nvim-navic

      # mini.[ai|comment|cursorword|moves|surround|sessions]
      mini-nvim
    ];

    extraPackages = with pkgs; [ ripgrep fd nil lua-language-server ];

    extraLuaConfig = builtins.concatStringsSep "\n" ((map builtins.readFile [
      ./config/options.lua
      ./config/keybindinds.lua

      ./config/lsp/neodev.lua
      ./config/lsp/lspconfig.lua
      ./config/lsp/nvim-cmp.lua

      ./config/plugins/nvim-treesitter.lua
      ./config/plugins/telescope-nvim.lua
      ./config/plugins/nvim-colorizer.lua
      ./config/plugins/tabout.lua
      ./config/plugins/gitsigns.lua
      ./config/plugins/lualine.lua
      ./config/plugins/indent-blankline-nvim.lua
      ./config/plugins/rainbow-delimiters.lua
      ./config/plugins/neoscroll.lua

      ./config/plugins/mini-ai.lua
      ./config/plugins/mini-comment.lua
      ./config/plugins/mini-move.lua
      ./config/plugins/mini-surround.lua
    ]) ++ [
      ''require('mini.cursorword').setup {}''
      ''require('nvim-autopairs').setup {}''
      ''require('mini.sessions').setup { autoread = true }''
    ]);

  };
}
