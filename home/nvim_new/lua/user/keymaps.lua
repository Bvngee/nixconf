local function map(mode, lhs, rhs, opts)
  local default_opts = { noremap = true, silent = true }
  if opts then
    opts = vim.tbl_extend('force', default_opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- save all and close all keybinds
map('n', '<C-s>', ':wa<CR>')
map('n', '<C-q>', ':wqa<CR>')

-- stay in visual mode when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- make buffers take relatively equal space (useful after resizes)
map('n', '<leader>=', '<C-w>=')

-- remove default Cmdwin hotkeys (doesn't work perfectly but eh)
map('n', 'q:', '<nop>', { remap = true, silent = true })
map('n', 'q/', '<nop>', { remap = true, silent = true })
map('n', 'q?', '<nop>', { remap = true, silent = true })

-- maintain register contents after paste
map('v', 'p', '"_dP')

-- easier-to-reach keybinds for moving to beginning/end of line
map({ 'n', 'v' }, 'H', '^')
map({ 'n', 'v' }, 'L', '$')

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
map('t', '<C-h>', '<C-w>h')
map('t', '<C-j>', '<C-w>j')
map('t', '<C-k>', '<C-w>k')
map('t', '<C-l>', '<C-w>l')

-- -- buffers resizing
-- map('n', '<A-,>', '<C-w><') -- horizontal
-- map('n', '<A-.>', '<C-w>>')
-- map('n', '<A-S-,>', '<C-w>5<')
-- map('n', '<A-S-.>', '<C-w>5>')
--
-- map('n', '<A-t>', '<C-w>+') -- vertical
-- map('n', '<A-s>', '<C-w>-')
-- map('n', '<A-S-t>', '<C-w>5+')
-- map('n', '<A-S-s>', '<C-w>5-')

-- standard diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)

-- keep screen centered after large movements
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-f>', '<C-f>zz')
map('n', '<C-b>', '<C-b>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- set better movement keybinds for wrap mode
function SetWrapKeymaps()
  if vim.wo.wrap then
    map({ 'n', 'v' }, 'j', 'gj')
    map({ 'n', 'v' }, 'k', 'gk')
    map({ 'n', 'v' }, 'L', 'g$')
    map({ 'n', 'v' }, 'H', 'g^')
  else
    vim.keymap.del({ 'n', 'v' }, 'j')
    vim.keymap.del({ 'n', 'v' }, 'k')
    map({ 'n', 'v' }, 'H', '^')
    map({ 'n', 'v' }, 'L', '$')
  end
end

-- toggle wrap mode and update movement hotkeys
map('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
  SetWrapKeymaps()
end)

-- lol, who doesn't mistype these sometimes?
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('Q', 'q', {})
