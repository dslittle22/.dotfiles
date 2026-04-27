vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-mini/mini.files",
})

vim.keymap.set("n", "<leader>E", "<Cmd>lua MiniFiles.open()<CR>")
vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
end, { desc = "Toggle file explorer (current file)" })

local show_dotfiles = false

local filter_show = function(entry)
  return entry.name ~= '.DS_Store'
end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, '.')
end

local toggle_dotfiles = function()
  print("hey there")
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak left-hand side of mapping to your liking
    vim.keymap.set('n', '<leader>de', toggle_dotfiles, { buffer = buf_id })
  end,
})

require('mini.files').setup({
  windows = {
    preview = true,
    width_preview = math.floor(vim.o.columns * 0.5),
  },
  content = {
    filter = filter_show },
})
