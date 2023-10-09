require('ibl').setup {
    indent = {
        char = '▏',
    },
    scope = {
        enabled = false
    },
    exclude = {
        buftypes = { 'terminal', 'nofile' },
        filetypes = {
            'help',
            'startify',
            'dashboard',
            'packer',
            'neogitstatus',
            'NvimTree',
            'Trouble',
            'text',
        },
    },
}
