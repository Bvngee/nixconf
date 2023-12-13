{ pkgs, lib, config, pkgsUnstable, ... }: let
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
  home.file.".config/testFile".source = config.lib.file.mkOutOfStoreSymlink ../../testFile;
  
  programs.neovim = {
    enable = true;
    
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # lsp
      neodev-nvim
      nvim-lspconfig
      nvim-jdtls # java specific

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
      ) + "\n" +
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
        ./config/lsp/nvim-jdtls.lua
        ./config/lsp/nvim-cmp.lua
      ]) + "\n" + ''
        require('mini.cursorword').setup {}
        require('nvim-autopairs').setup {}
        require('guess-indent').setup {}
        require('crates').setup { src = { cmp = { enabled = true } } }
        require('luasnip.loaders.from_vscode').lazy_load()
      '';
  };
}
