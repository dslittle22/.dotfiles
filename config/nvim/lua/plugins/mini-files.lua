return {
  'nvim-mini/mini.files',
  version = '*',
  keys = {
    {
      "<leader>e",
      function()
        if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
      end,
      desc = "Toggle file explorer (current file)",
    },
    { "<leader>E", "<Cmd>lua MiniFiles.open()<CR>", desc = "Open file explorer (cwd)" },
  },
  opts = {
    options = {
      use_as_default_explorer = true,
    },
    windows = {
      preview = true,
      width_focus = math.floor(vim.o.columns * 0.25),
      width_nofocus = math.floor(vim.o.columns * 0.1),
      width_preview = math.floor(vim.o.columns * 0.3),
    },
  },
  config = function(_, opts)
    require('mini.files').setup(opts)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf = args.data.buf_id
        vim.keymap.set('n', '<Left>', 'h', { buffer = buf, remap = true })
        vim.keymap.set('n', '<Right>', 'l', { buffer = buf, remap = true })
        vim.keymap.set('n', '<Up>', 'k', { buffer = buf, remap = true })
        vim.keymap.set('n', '<Down>', 'j', { buffer = buf, remap = true })
        vim.keymap.set('n', '<CR>', function()
          MiniFiles.go_in({ close_on_file = true })
        end, { buffer = buf })
      end,
    })
  end,
}
