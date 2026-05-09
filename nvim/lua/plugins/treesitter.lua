return { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
    config = function()
        local configs = require("nvim-treesitter.config")
        configs.setup({
            ensure_installed = { "lua", "javascript", "python", "c", "html" },
            highlight = { enable = true },
            auto_install = true,
            indent = { enable = true },
        })
    end
}
