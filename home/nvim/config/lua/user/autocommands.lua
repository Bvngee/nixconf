-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 75, higroup = 'Visual' })
  end,
})

-- For these filetypes, comments AND text should be autowrapped when typing past
-- 80 chars. (see options.lua for default formatoptions)
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown', 'text', 'typst', 'plaintex' },
  callback = function()
    vim.opt_local.formatoptions:append('t')
  end,
})
-- For languages without formatters that can enforce strict line wrap (like
-- prettier does for markdown), use vim's builtin paragraph autoformatting. It's
-- annoyingly too agressive, so I'd prefer to use an external formatter for
-- linewrapping when supported.
-- See https://github.com/Enter-tainer/typstyle/issues/104
-- just kidding, this shit is too annoying
-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   pattern = { 'typst' },
--   callback = function()
--     -- also see https://chatgpt.com/c/67ccc688-a078-800e-a792-ef332b7a45b6
--     vim.opt_local.formatoptions:append('a')
--     vim.opt_local.formatoptions:append('2') -- use 2nd line for autoformatting
--   end,
-- })

-- just setting `vim.opt_local.formatoptions:remove('o')` doesn't work, as neovim
-- resets it later itself in ftplugin/lua.vim or smth (taken from chris@machine)
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function()
    vim.cmd('set formatoptions-=o')
  end,
})

-- temporary hackfix for "uv_close: Assertion `!uv__is_closing(handle)` failed."
-- https://github.com/neovim/neovim/issues/21856
vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  callback = function()
    vim.fn.jobstart('', { detach = true })
  end,
})
