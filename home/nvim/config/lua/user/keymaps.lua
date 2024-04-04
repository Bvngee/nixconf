local function map(mode, lhs, rhs, opts)
  local default_opts = { remap = false, silent = true }
  if opts then
    opts = vim.tbl_extend('force', default_opts, opts)
  else
    opts = default_opts
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- left/right end of line that works with wrapped lines (and easier-to-reach)
-- NOTE: currently this is copy-pasted into ./plugins/smart-splits.lua to reset
-- the mappings properly.
map({ 'n', 'v' }, 'H', function()
  return vim.wo.wrap and 'g^' or '^'
end, { remap = true, expr = true })
map({ 'n', 'v' }, 'L', function()
  return vim.wo.wrap and 'g$' or '$'
end, { remap = true, expr = true })

-- save all and close all keybinds
map('n', '<C-s>', ':wa<CR>')
map('n', '<C-q>', ':qa<CR>')

-- clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>')

-- remove default Cmdwin hotkeys (doesn't work perfectly but eh)
map('n', 'q:', '<nop>', { remap = true })
map('n', 'q/', '<nop>', { remap = true })
map('n', 'q?', '<nop>', { remap = true })

-- maintain register contents after paste
map('v', 'p', '"_dP')

-- easier [delete/change]-without-yank keybind
map({ 'n', 'v' }, '<leader>d', '"_d')
map({ 'n', 'v' }, '<leader>D', '"_D')
map({ 'n', 'v' }, '<leader>c', '"_c')
map({ 'n', 'v' }, '<leader>C', '"_C')

-- x key doesn't yank
map({ 'n', 'v' }, 'x', '"_x')
map({ 'n', 'v' }, 'X', '"_X')

-- yank to system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>Y', '"+Y')

-- buffer navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- manage splits easier
map('n', '<leader>wx', '<cmd>split<cr>')
map('n', '<leader>wv', '<cmd>vsplit<cr>')
map('n', '<leader>wc', '<C-w>c')

-- make buffers take relatively equal space (useful after resizes)
map('n', '<leader>w=', '<C-w>=')

-- Exit terminal mode easier. NOTE: This might not work in all terminal emulators/tmux/etc.
map('t', '<Esc><Esc>', '<C-\\><C-n>')

-- keep screen centered after large movements
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-f>', '<C-f>zz')
map('n', '<C-b>', '<C-b>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- toggle wrap mode and update movement hotkeys
map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end)

-- lol, who doesn't mistype these sometimes?
vim.api.nvim_create_user_command('WQa', 'wqa', {})
vim.api.nvim_create_user_command('Wqa', 'wqa', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('Q', 'q', {})
