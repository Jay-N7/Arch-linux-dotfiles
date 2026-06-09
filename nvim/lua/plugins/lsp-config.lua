return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls","pyright", "ts_ls", "clangd", "bashls",

                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", { capabilities = capabilities, })


            -- lua_ls config
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = { runtime = { version = "LuaJIT", },
                    diagnostics = { globals = { "vim" }, },
                    workspace = {
                        -- library = vim.api.nvim_get_runtime_file("", true),
                         library = { vim.env.VIMRUNTIME, "/usr/share/hypr/stubs", },
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false, },
                },
            },
        })


            vim.lsp.enable("lua_ls")
            vim.lsp.enable("pyright")
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("clangd")
            vim.lsp.enable("bashls")

            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
            vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {})
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {})
            vim.keymap.set("n", "<leader>te", function()
                local enabled = vim.diagnostic.is_enabled()
                vim.diagnostic.enable(not enabled)
            end, { desc = "Toggle diagnostics" })

        end,
    },
}
