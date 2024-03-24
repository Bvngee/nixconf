require('user.options')
require('user.keymaps')
require('user.autocommands')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('user.plugins', {
  change_detection = {
    -- get rid of annoying warning messages
    enabled = false,
  },
})

vim.keymap.set('n', '<leader>la', require('lazy').home)
