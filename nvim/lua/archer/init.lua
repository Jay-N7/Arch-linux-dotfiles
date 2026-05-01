require("archer.remap")
require("archer.set")
require("archer.packer")
require("archer.completions")
require("archer.lsp")

require('telescope').setup({})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
