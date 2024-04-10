vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.mouse = 'a'
vim.o.mousemodel = 'extend'
vim.o.termguicolors = true
vim.o.fileencoding = 'utf-8'
vim.o.fsync = true
vim.o.showmode = false
vim.o.wrap = false
vim.o.wrapscan = true
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.signcolumn = 'yes:1'
vim.o.undofile = true
vim.g.netrw_banner = 0 -- is this the correct var name?

-- used with autosession
-- removed 'localoptions' - autosession gets weird setting incorrect values
vim.o.sessionoptions =
  'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

-- (lua and vimscript plugins only)
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
vim.o.cedit = '<C-f>'
vim.o.cmdwinheight = 3
vim.o.showcmdloc = 'statusline'
vim.o.laststatus = 3
vim.opt.shortmess:append('IcC')
vim.opt.shortmess:remove('sS')
vim.o.updatetime = 200
vim.o.hidden = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.inccommand = 'split'
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true
