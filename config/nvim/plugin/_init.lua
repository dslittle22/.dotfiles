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
})


require('mini.files').setup({
  windows = { preview = true }
})

vim.keymap.set("n", "leaderE", "<Cmd>lua MiniFiles.open()<CR>")
vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
end, { desc = "Toggle file explorer (current file)" })

vim.cmd.colorscheme('alabaster')

require("nvim-autopairs").setup()

require('blink.indent').setup({
  static = { enabled = false },
  scope = {
    enabled = true,
    highlights = { 'BlinkIndent' },
  },
})
