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
    -- vim.wo.spell = true
    vim.wo.wrap = true
    SetWrapKeymaps() -- defined in keymaps.lua
  end,
})
