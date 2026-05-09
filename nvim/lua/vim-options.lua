vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.keymap.set("n", "<leader>op", vim.cmd.Ex)
vim.keymap.set("x", "<leader>p", "\"_dP")
-- This yanks to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = true

vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.guicursor= ""

vim.cmd("filetype plugin indent on")
vim.opt.fillchars = { eob = " " }

local function transparent()
    local bg = "none"
    vim.api.nvim_set_hl(0, "Normal", { bg = bg })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })
    -- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = bg })
    -- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = bg })
end

transparent()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = transparent,
})
---- The blow forces NO BACKGROUND (thus following kittys transparency)
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
---- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
---- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
--vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
--vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
---- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
--
