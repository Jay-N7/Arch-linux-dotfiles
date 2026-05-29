return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local my_theme = {
            normal = {
                a = { bg = '#ff007f', fg = '#000000', gui = 'bold' },
                b = { bg = '#222222', fg = '#ffffff' },
                c = { bg = '#111111', fg = '#cccccc' },
            },
            insert = {
                a = { bg = '#00ff00', fg = '#000000', gui = 'bold' },
            },
            command = {
                a = { bg = '#ff0000', fg = '#ffffff', gui = 'bold' },
            },
            visual = {
                a = { bg = '#ffaa00', fg = '#000000', gui = 'bold' },
            },
            replace = {
                a = { bg = '#ff4444', fg = '#ffffff', gui = 'bold' },
            },
            inactive = {
                a = { bg = '#000000', fg = '#666666' },
                b = { bg = '#000000', fg = '#666666' },
                c = { bg = '#000000', fg = '#666666' },
            },
        }
        require('lualine').setup({
            options = {
                theme = "rose-pine"
                -- theme = "dracula"
                -- theme = my_theme
            }
        })
    end
}

