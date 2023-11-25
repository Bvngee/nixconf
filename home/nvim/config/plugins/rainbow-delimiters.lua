-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

-- not sure if the following is needed?
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterOrange',
        'RainbowDelimiterYellow',
        'RainbowDelimiterGreen',
        'RainbowDelimiterCyan',
        'RainbowDelimiterBlue',
        'RainbowDelimiterViolet',
    },
}
