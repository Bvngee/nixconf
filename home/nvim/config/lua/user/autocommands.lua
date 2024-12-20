-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 75, higroup = 'Visual' })
  end,
})

-- Enable line wrapping and spell checking in certain file types
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.wo.wrap = true -- toggle with <leader>ww (keymaps.lua)
  end,
})

-- just setting `vim.opt_local.formatoptions:remove('o')` doesn't work, as neovim
-- resets it later itself in ftplugin/lua.vim or smth (taken from chris@machine)
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function()
    vim.cmd('set formatoptions-=o')
  end,
})

-- temporary hackfix for "uv_close: Assertion `!uv__is_closing(handle)` failed."
-- https://github.com/neovim/neovim/issues/21856
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.fn.jobstart("", { detach = true })
  end,
})
