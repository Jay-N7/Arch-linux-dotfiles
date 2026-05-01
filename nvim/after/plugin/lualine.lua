local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
  return
end

lualine.setup({
options = {
  theme = 'auto',

  -- sharp / angular separators (not curved)
  section_separators = { left = '', right = '' },
  component_separators = { left = '', right = '' },

  globalstatus = true,
  icons_enabled = true,
},
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'diagnostics', 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
