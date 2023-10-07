{ pkgs, inputs, ... }: {
  programs.neovim = {
    enable = true;
    #package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.neovim;
    
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      #lsp
      nvim-lspconfig

      #cmp
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-treesitter
      cmp_luasnip
      neodev-nvim

      #snippets
      luasnip
      friendly-snippets

      #treesitter
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      nvim-treesitter-textobjects
      nvim-ts-rainbow2

      #util
      plenary-nvim
      nvim-web-devicons
      popup-nvim
      
      #other
      gitsigns-nvim
      nvim-autopairs
      telescope-nvim
      telescope-zf-native-nvim
      #telescope-file-browser-nvim
      
    ];

    extraPackages = with pkgs; [ ripgrep fd nil lua-language-server ];

    extraLuaConfig = builtins.concatStringsSep "\n" (map builtins.readFile [
      ./config/options.lua
      ./config/keybindinds.lua
      ./config/lsp/neodev.lua
      ./config/plugins/nvim-treesitter.lua
      ./config/plugins/telescope-nvim.lua
    ]);

  };
}
