-- return {
-- 'olimorris/persisted.nvim',
-- event = 'VeryLazy',
-- opts = {
--   silent = false, -- silent nvim message when sourcing session file
--   use_git_branch = true, -- create session files based on the branch of a git enabled repository
--   default_branch = 'main', -- the branch to load if a session file is not found for the current branch
--   autosave = true, -- automatically save session files when exiting Neovim
--   should_autosave = nil, -- function to determine if a session should be autosaved
--   autoload = true, -- automatically load the session for the cwd on Neovim startup
--   on_autoload_no_session = function()
--     vim.notify('No existing session to load!')
--   end, -- function to run when `autoload = true` but there is no session to load
--   follow_cwd = true, -- change session file name to match current working directory if it changes
--   allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
--   ignored_dirs = { '~/', '~/dev', '~/Developer', '~/Downloads' }, -- table of dirs that are ignored when auto-saving and auto-loading
--   ignored_branches = nil, -- table of branch patterns that are ignored for auto-saving and auto-loading
--   telescope = {
--     reset_prompt = true, -- Reset the Telescope prompt after an action?
--     mappings = { -- table of mappings for the Telescope extension
--       change_branch = '<c-b>',
--       copy_session = '<c-c>',
--       delete_session = '<c-d>',
--     },
--   },
-- },
-- }

return {
  'rmagatti/auto-session',
  -- event = 'VeryLazy', -- this breaks session loading afaict
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'folke/noice.nvim', -- for loading order
  },
  opts = function()
    vim.keymap.set('n', '<leader>ss', require('auto-session.session-lens').search_session)
    vim.keymap.set('n', '<leader>ls', '<cmd>SessionRestore<cr>')

    return {
      log_level = 'info',
      auto_session_enable_last_session = false, -- Loads the last loaded session if session for cwd does not exist
      auto_session_enabled = true, -- Enables/disables the plugin's auto save and restore features
      auto_session_create_enabled = true, -- Enables/disables the plugin's session auto creation,
      auto_save_enabled = true, -- Enables/disables auto saving,
      auto_restore_enabled = false, -- Enables/disables auto restoring,
      auto_session_suppress_dirs = { '~/', '~/dev', '~/Developer', '~/Downloads' }, -- Suppress session create/restore if in one of the list of dirs,
      auto_session_allowed_dirs = nil, -- Allow session create/restore if in one of the list of dirs,
      auto_session_use_git_branch = true, -- Use the git branch to differentiate the session name,
      bypass_session_save_file_types = { 'nofile', 'terminal' }, -- table: Bypass auto save when only buffer open is one of these file types
      cwd_change_handling = { -- table: Config for handling the DirChangePre and DirChanged autocmds, can be set to nil to disable altogether
        restore_upcoming_session = true, -- boolean: restore session for upcoming cwd on cwd change
        pre_cwd_changed_hook = nil, -- function: This is called after auto_session code runs for the `DirChangedPre` autocmd
        post_cwd_changed_hook = nil, -- function: This is called after auto_session code runs for the `DirChanged` autocmd
      },
    }
  end,
}
