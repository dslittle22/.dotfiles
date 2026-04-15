vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://tpope.io/vim/surround.git",
  "https://tpope.io/vim/rhubarb.git",
  "https://tpope.io/vim/fugitive.git",
  "https://github.com/nvim-mini/mini.files",
  "https://github.com/dchinmay2/alabaster.nvim",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/saghen/blink.indent",
  "https://github.com/esmuellert/codediff.nvim",
})


require('mini.files').setup({
  windows = {
    preview = true,
    width_preview = math.floor(vim.o.columns * 0.5),
  },
  content = {
    filter = function(entry)
      return entry.name ~= '.DS_Store'
    end,
  },
})

vim.keymap.set("n", "<leader>E", "<Cmd>lua MiniFiles.open()<CR>")
vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
end, { desc = "Toggle file explorer (current file)" })

vim.cmd.colorscheme('alabaster')

require("nvim-autopairs").setup()

if require('hubspot').is_hubspot() then
  require('hubspot.plugins')
end

require('blink.indent').setup({
  static = { enabled = false },
  scope = {
    enabled = true,
    highlights = { 'BlinkIndent' },
  },
})
