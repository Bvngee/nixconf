require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true;
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
  },
}
