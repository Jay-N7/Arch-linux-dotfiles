local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
  return
end

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

lualine.setup({
  options = {
    theme = my_theme,

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
