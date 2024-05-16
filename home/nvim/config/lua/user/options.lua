vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.mouse = 'a'
opt.mousemodel = 'extend'
opt.termguicolors = true
opt.fileencoding = 'utf-8'
opt.fsync = true
opt.showmode = false
opt.wrap = false
opt.wrapscan = true
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.signcolumn = 'yes:1'
opt.undofile = true
vim.g.netrw_banner = 0 -- is this the correct var name?

-- used with autosession
-- removed 'localoptions' - autosession gets weird setting incorrect values
opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

-- also see conform.nvim, :h fo-table
opt.formatoptions = opt.formatoptions
  - 'a' -- autoformatting
  - 't' -- dont autowrap all text with '\n'
  + 'c' -- do autowrap comments
  - 'o' -- (also set in autocommands.lua)
  + 'r'
  - 'q'
  - 'n'
  - '2'
  + 'j'

-- (lua and vimscript plugins only)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.mousemoveevent = true
opt.splitbelow = true
opt.splitright = true
opt.cmdheight = 0
opt.cedit = '<C-f>'
opt.cmdwinheight = 3
opt.showcmdloc = 'statusline'
opt.laststatus = 3
opt.shortmess:append('IcC')
opt.shortmess:remove('sS')
opt.updatetime = 200
opt.hidden = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.inccommand = 'nosplit' -- split enables the preview winow when doing substitutions and similar things
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
