local opts = { noremap = true, silent = true }
local function map(mode, shortcut, command, options)
  vim.keymap.set(mode, shortcut, command, options)
end

-- save all and close all keybinds
map('n', '<C-s>', ':wa<CR>', opts)
map('n', '<C-q>', ':wqa<CR>', opts)

-- stay in visual mode when indenting
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- make buffers take relatively equal space (useful after resizes)
map('n', '<leader>=', '<C-w>=', opts)

-- remove default Cmdwin hotkeys (doesn't work perfectly but eh)
map('n', 'q:', '<nop>', { remap = true, silent = true })
map('n', 'q/', '<nop>', { remap = true, silent = true })
map('n', 'q?', '<nop>', { remap = true, silent = true })

-- maintain register contents after paste
map('v', 'p', '"_dP', opts)

-- easier [delete/change]-without-yank keybind
map({ 'n', 'v' }, '<leader>d', '"_d', opts)
map({ 'n', 'v' }, '<leader>D', '"_D', opts)
map({ 'n', 'v' }, '<leader>c', '"_c', opts)
map({ 'n', 'v' }, '<leader>C', '"_C', opts)

-- x key doesn't yank
map({ 'n', 'v' }, 'x', '"_x', opts)
map({ 'n', 'v' }, 'X', '"_X', opts)

-- yank to system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>Y', '"+Y', opts)

-- buffer navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- -- buffers resizing
-- map('n', '<A-,>', '<C-w><', opts) -- horizontal
-- map('n', '<A-.>', '<C-w>>', opts)
-- map('n', '<A-S-,>', '<C-w>5<', opts)
-- map('n', '<A-S-.>', '<C-w>5>', opts)
--
-- map('n', '<A-t>', '<C-w>+', opts) -- vertical
-- map('n', '<A-s>', '<C-w>-', opts)
-- map('n', '<A-S-t>', '<C-w>5+', opts)
-- map('n', '<A-S-s>', '<C-w>5-', opts)

-- standard diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev, opts)
map('n', ']d', vim.diagnostic.goto_next, opts)

-- keep screen centered after large movements
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-f>', '<C-f>zz', opts)
map('n', '<C-b>', '<C-b>zz', opts)
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- toggle line wrap
map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, opts)

-- lol, who doesn't mistype these sometimes?
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('Q', 'q', {})
