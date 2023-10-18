require('persisted').setup {
  save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
  silent = false, -- silent nvim message when sourcing session file
  use_git_branch = false, -- create session files based on the branch of the git enabled repository
  autosave = true, -- automatically save session files when exiting Neovim
  should_autosave = function()
    return not (vim.bo.filetype == "" or vim.bo.filetype == nil)
  end, -- function to determine if a session should be autosaved
  autoload = false, -- automatically load the session for the cwd on Neovim startup
  on_autoload_no_session = function()
    vim.notify("No existing session to load.") 
  end, -- function to run when `autoload = true` but there is no session to load
  follow_cwd = true, -- change session file name to match current working directory if it changes
  allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
  ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
  telescope = { -- options for the telescope extension
    reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
  },
}


-- fix for https://github.com/neovim/neovim/issues/21856 (related: https://github.com/olimorris/persisted.nvim/issues/84 )
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    -- vim.cmd('!notify-send  "hello"')
    vim.cmd('sleep 10m')
  end,
})
