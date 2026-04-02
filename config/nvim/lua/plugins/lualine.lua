return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      section_separators = "",
      component_separators = ""
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { { 'branch', icons_enabled = false }, 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 3, file_status = true, shorting_target = 40, } },
      lualine_x = {
        { 'lsp_status', ignore_lsp = { 'eslint', 'null-ls' }, show_name = false },
        { 'filetype',   icon_only = true },
      },
      lualine_y = { 'searchcount', 'progress' },
      lualine_z = { 'location' }
    },
  }
}
