local function tmap(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { silent = true })
end

local function map(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end



-- telescope
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>fg', builtin.git_files)
map('n', '<leader>lg', builtin.live_grep)
