return {
  'hiphish/rainbow-delimiters.nvim',
  event = 'BufEnter',
  config = function()
    local rd = require('rainbow-delimiters')
    require('rainbow-delimiters.setup').setup({
      -- all coppied from the readme
      strategy = {
        [''] = rd.strategy['global'],
        -- vim = rd.strategy['local'],
        -- zig = rd.strategy['noop'], -- lag seems to be fixed!
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterOrange',
        'RainbowDelimiterYellow',
        'RainbowDelimiterGreen', -- maybe yeet this one too?
        -- 'RainbowDelimiterCyan',
        'RainbowDelimiterBlue',
        'RainbowDelimiterViolet',
      },
    })
  end,
}
