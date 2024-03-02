vim.g.mapleader = ' '
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.fileencoding = 'utf-8'
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.signcolumn = 'yes'
vim.o.undofile = true
vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

-- (lua and vimscript plugins only )
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.mousemoveevent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cmdheight = 0
vim.o.showcmdloc = "statusline"
vim.o.laststatus = 2
vim.o.updatetime = 100
vim.o.hidden = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.incsearch = true
vim.o.hlsearch = true

vim.o.termguicolors = true
