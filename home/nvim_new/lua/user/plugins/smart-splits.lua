return {
  'mrjones2014/smart-splits.nvim',
  dependencies = {
    'kwkarlwang/bufresize.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local smart_splits = require('smart-splits')
    local opts = {
      ignored_buftypes = {
        'nofile',
        'quickfix',
        'prompt',
      },
      ignored_filetypes = { 'NvimTree' },
      default_amount = 3,
      at_edge = 'stop',
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = true,
      resize_mode = {
        quit_key = '<ESC>',
        resize_keys = { 'h', 'j', 'k', 'l' },
        silent = true,
        hooks = {
          on_enter = function()
            vim.notify('Entering resize mode: use h/j/k/l to resize')
          end,
          on_leave = function()
            vim.notify('Exiting resize mode, all keymaps restored')
            require('bufresize').register()
          end,
        },
      },
      ignored_events = {
        'BufEnter',
        'WinEnter',
      },
      multiplexer_integration = nil,
      log_level = 'info',
    }

    smart_splits.setup(opts)

    -- TODO: do i want to keep using arrow keys? do I want resize mode / regular keymaps / both?
    -- resizing splits
    vim.keymap.set('n', '<C-left>', function() smart_splits.resize_left(1) end)
    vim.keymap.set('n', '<C-right>', function() smart_splits.resize_right(1) end)
    vim.keymap.set('n', '<C-up>', function() smart_splits.resize_up(1) end)
    vim.keymap.set('n', '<C-down>', function() smart_splits.resize_down(1) end)
    vim.keymap.set('n', '<C-S-left>', function() smart_splits.resize_left(5) end)
    vim.keymap.set('n', '<C-S-right>', function() smart_splits.resize_right(5) end)
    vim.keymap.set('n', '<C-S-up>', function() smart_splits.resize_up(5) end)
    vim.keymap.set('n', '<C-S-down>', function() smart_splits.resize_down(5) end)
    -- moving between splits
    vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
    vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
    vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
    vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
    -- swapping buffers between windows
    vim.keymap.set('n', '<leader><leader>h', smart_splits.swap_buf_left)
    vim.keymap.set('n', '<leader><leader>j', smart_splits.swap_buf_down)
    vim.keymap.set('n', '<leader><leader>k', smart_splits.swap_buf_up)
    vim.keymap.set('n', '<leader><leader>l', smart_splits.swap_buf_right)
    -- persistent rezize mode
    vim.keymap.set('n', '<leader>rs', smart_splits.start_resize_mode)
  end,
}
