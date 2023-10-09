vim.g.mapleader = ','
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.fileencoding = 'utf-8'
vim.o.wrap = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.signcolumn = 'yes'
vim.o.undofile = true

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
vim.o.laststatus = 3
vim.o.updatetime = 50
vim.o.hidden = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.incsearch = true
vim.o.hlsearch = true

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.g.gruvbox_material_disasble_italic_comment = 1
vim.g.gruvbox_material_better_performance = 0
vim.g.gruvbox_materialediagnostic_virtual_text = 'colored'
vim.cmd.colorscheme('gruvbox-material')

-- get the gruvbox_material palette in order to setup nvim-navic and rainbow-delimiters
local gruvbox_config = vim.api.nvim_call_function('gruvbox_material#get_configuration', {})
local gruvbox_palette = vim.api.nvim_call_function(
    'gruvbox_material#get_palette',
    { gruvbox_config.background, gruvbox_config.foreground, gruvbox_config.colors_override }
)
for k, v in pairs(gruvbox_palette) do
    gruvbox_palette[k] = v[1]
end

-- setup nvim-navic
vim.api.nvim_set_hl(0, 'NavicIconsFile', { fg = gruvbox_palette.fg0, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsModule', { fg = gruvbox_palette.yellow, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsNamespace', { fg = gruvbox_palette.fg0, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsPackage', { fg = gruvbox_palette.red, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsClass', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsMethod', { fg = gruvbox_palette.blue, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsProperty', { fg = gruvbox_palette.green, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsField', { fg = gruvbox_palette.green, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsConstructor', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsEnum', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsInterface', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsFunction', { fg = gruvbox_palette.blue, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsVariable', { fg = gruvbox_palette.purple, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsConstant', { fg = gruvbox_palette.purple, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsString', { fg = gruvbox_palette.green, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsNumber', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsBoolean', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsArray', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsObject', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsKey', { fg = gruvbox_palette.purple, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsKeyword', { fg = gruvbox_palette.purple, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsNull', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsEnumMember', { fg = gruvbox_palette.green, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsStruct', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsEvent', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsOperator', { fg = gruvbox_palette.fg0, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicIconsTypeParameter', { fg = gruvbox_palette.green, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicText', { fg = gruvbox_palette.fg0, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'NavicSeparator', { fg = gruvbox_palette.fg1, bg = gruvbox_palette.none })

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = gruvbox_palette.red, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = gruvbox_palette.yellow, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = gruvbox_palette.blue, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = gruvbox_palette.orange, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = gruvbox_palette.green, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = gruvbox_palette.purple, bg = gruvbox_palette.none })
vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = gruvbox_palette.aqua, bg = gruvbox_palette.none })
