-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

-- Telescope
use {
  'nvim-telescope/telescope.nvim',  
  branch = 'master',
  requires = { {'nvim-lua/plenary.nvim'} }
}

-- color scheme rose pine 
use({
	'rose-pine/neovim',
	as = 'rose-pine',
	config = function()
		vim.cmd('colorscheme rose-pine')
	end
})

-- treesitter
use({
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate'
})


-- Lua line 

use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons' }
}

-- For auto competion using LSP
 use 'hrsh7th/nvim-cmp'
 use 'hrsh7th/cmp-nvim-lsp'

 use 'hrsh7th/cmp-buffer'
 -- Snippet engine
 use 'L3MON4D3/LuaSnip'
 -- Snippet completion source for LuaSnip
 use 'saadparwaiz1/cmp_luasnip'
 -- VSCode-style snippets (THIS is what you're missing)
 use 'rafamadriz/friendly-snippets'

-- LSP installer + manager
use 'williamboman/mason.nvim'
use 'williamboman/mason-lspconfig.nvim'

-- Core LSP support
use 'neovim/nvim-lspconfig'
end)
