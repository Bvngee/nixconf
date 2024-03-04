return {
  'mrjones2014/smart-splits.nvim',
  opts = {
    -- Ignored buffer types (only while resizing)
    ignored_buftypes = {
      'nofile',
      'quickfix',
      'prompt',
    },
    -- Ignored filetypes (only while resizing)
    ignored_filetypes = { 'NvimTree' },
    -- the default number of lines/columns to resize by at a time
    default_amount = 3,
    -- Desired behavior when your cursor is at an edge and you
    -- are moving towards that same edge:
    -- 'wrap' => Wrap to opposite side
    -- 'split' => Create a new split in the desired direction
    -- 'stop' => Do nothing
    -- function => You handle the behavior yourself
    -- NOTE: If using a function, the function will be called with
    -- a context object with the following fields:
    -- {
    --    mux = {
    --      type:'tmux'|'wezterm'|'kitty'
    --      current_pane_id():number,
    --      is_in_session(): boolean
    --      current_pane_is_zoomed():boolean,
    --      -- following methods return a boolean to indicate success or failure
    --      current_pane_at_edge(direction:'left'|'right'|'up'|'down'):boolean
    --      next_pane(direction:'left'|'right'|'up'|'down'):boolean
    --      resize_pane(direction:'left'|'right'|'up'|'down'):boolean
    --      split_pane(direction:'left'|'right'|'up'|'down',size:number|nil):boolean
    --    },
    --    direction = 'left'|'right'|'up'|'down',
    --    split(), -- utility function to split current Neovim pane in the current direction
    --    wrap(), -- utility function to wrap to opposite Neovim pane
    -- }
    -- NOTE: `at_edge = 'wrap'` is not supported on Kitty terminal
    -- multiplexer, as there is no way to determine layout via the CLI
    at_edge = 'stop',
    -- when moving cursor between splits left or right,
    -- place the cursor on the same row of the *screen*
    -- regardless of line numbers. False by default.
    -- Can be overridden via function parameter, see Usage.
    move_cursor_same_row = false,
    -- whether the cursor should follow the buffer when swapping
    -- buffers by default; it can also be controlled by passing
    -- `{ move_cursor = true }` or `{ move_cursor = false }`
    -- when calling the Lua function.
    cursor_follows_swapped_bufs = true,

    resize_mode = {
      quit_key = '<ESC>',
      -- keys to use for moving in resize mode
      -- in order of left, down, up, right
      resize_keys = { 'h', 'j', 'k', 'l' },
      -- set to true to silence the notifications
      -- when entering/exiting persistent resize mode
      silent = false,
      -- must be functions, they will be executed when
      -- entering or exiting the resize mode
      hooks = {
        on_enter = nil,
        on_leave = nil,
      },
    },
    -- ignore these autocmd events (via :h eventignore) while processing
    -- smart-splits.nvim computations, which involve visiting different
    -- buffers and windows. These events will be ignored during processing,
    -- and un-ignored on completed. This only applies to resize events,
    -- not cursor movement events.
    ignored_events = {
      'BufEnter',
      'WinEnter',
    },
    multiplexer_integration = nil,
    -- default logging level, one of: 'trace'|'debug'|'info'|'warn'|'error'|'fatal'
    log_level = 'info',
  },
  config = function(opts)
    local smart_splits = require('smart-splits')
    -- TODO: do i want to keep using arrow keys? do I want resize mode / regular keymaps / both?
    -- resizing splits
    vim.keymap.set('n', '<C-left>', function() smart_splits.resize_left(2) end)
    vim.keymap.set('n', '<C-right>', function() smart_splits.resize_right(2) end)
    vim.keymap.set('n', '<C-up>', function() smart_splits.resize_up(2) end)
    vim.keymap.set('n', '<C-down>', function() smart_splits.resize_down(2) end)
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
