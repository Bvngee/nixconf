local function tmap(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { silent = true })
end

local function map(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

--- General Keymaps ---

-- save and close all
map('n', '<S-q>', ':xa<CR>')

-- stay in visual mode when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- moving text up and down
map('v', '<A-j>', ':m .+1<CR>==')
map('v', '<A-k>', ':m .-2<CR>==')
map('n', '<A-j>', ':m .+1<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')

-- maintain register contents after paste
map('v', 'p', '"_dP')

-- easier delete-without-yank keybind
map('n', '_d', '"_d')

-- x key doesn't yank
map('n', 'x', '"_x')
map('v', 'x', '"_x')

-- yank to system clipboard
map('v', '<leader>y', '"*y')

-- buffer navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- standard diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)

--- Plugin Keymaps ---

-- telescope
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>fg', builtin.git_files)
map('n', '<leader>lg', builtin.live_grep)
