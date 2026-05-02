function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()

-- Reapply after PackerSync
vim.api.nvim_create_autocmd("User", {
	pattern = "PackerComplete",
	callback = function()
		ColorMyPencils()
	end,
})
