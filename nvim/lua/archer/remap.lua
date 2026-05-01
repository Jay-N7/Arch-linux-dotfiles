vim.g.mapleader = " "
-- This opens Explore
vim.keymap.set("n", "<leader>op", vim.cmd.Ex)
-- This does a paste replacing something without loosing whats in the regsiter
vim.keymap.set("x", "<leader>p", "\"_dP")
-- This yanks to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- This shows the diagnostics (warning/error) message on the line cursor is
vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float)

-- This toggles on and off diagnsotcis (error messages)
vim.keymap.set("n", "<leader>te", function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
end, { desc = "Toggle diagnostics" })




-- Opens file under cursor in split view
vim.keymap.set("n", "<leader>vs", vim.cmd.vs)
