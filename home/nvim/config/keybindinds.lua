local function tmap(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { silent = true })
end

local function map(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

--- General Keymaps ---

-- save all and close all keybinds
map('n', 'S', ':wa<CR>')
map('n', 'Q', ':wqa<CR>')

-- stay in visual mode when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- maintain register contents after paste
map('v', 'p', '"_dP')

-- easier delete-without-yank keybind
map('n', '<leader>d', '"_d')
map('v', '<leader>d', '"_d')
map('n', '<leader>D', '"_D')

-- x key doesn't yank
map('n', 'x', '"_x') 
map('v', 'x', '"_x')
map('n', 'X', '"_X')
map('v', 'X', '"_X')

-- yank to system clipboard
map('n', '<leader>y', '"+y')
map('v', '<leader>y', '"+y')
map('n', '<leader>Y', '"+Y')

-- buffer navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

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

-- start a replace under current word
map('n', '<leader>sw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- lol, who doesn't mistype these sometimes?
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('Q', 'q', {})



--- Plugin Keymaps ---

-- telescope
local builtin = require('telescope.builtin')
local extensions = require('telescope').extensions
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>fg', builtin.git_files)
map('n', '<leader>fb', builtin.buffers)
map('n', '<leader>lg', builtin.live_grep)
map('n', '<leader>ss', extensions.persisted.persisted)
