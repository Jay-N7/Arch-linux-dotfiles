-- Install parsers and enable basic features
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

-- Install parsers for languages you use
require('nvim-treesitter').install { 'c', 'lua', 'rust', 'vim', 'vimdoc', 'python' }

-- Enable syntax highlighting for ALL filetypes automatically
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})


-- Optional: Enable Treesitter-based indentation (experimental)
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
