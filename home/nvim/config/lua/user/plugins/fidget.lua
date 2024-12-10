return {
  'j-hui/fidget.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('fidget').setup({
      notification = {
        override_vim_notify = true,
        window = {
          winblend = 100,
          -- border = 'single',
        },
      },
      -- Options related to LSP progress subsystem
      progress = {
        display = {
          render_limit = 10, -- How many LSP messages to show at once
          done_ttl = 0.8, -- How long a message should persist after completion
          -- How to format a progress message
          format_message = function(msg)
            return require('fidget.progress.display').default_format_message(msg)
          end,
          -- How to format a progress annotation
          format_annote = function(msg)
            return msg.title
            -- return nil
          end,
          -- How to format a progress notification group's name
          format_group_name = function(group)
            return tostring(group)
            -- return nil
          end,
        },
      },
    })
  end,
}
