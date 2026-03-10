return {
  {
    "tpope/vim-commentary",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "gc", "<Plug>ContextCommentary")
      vim.keymap.set("n", "gcc", "<Plug>ContextCommentaryLine")
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ts_context_commentstring").setup({ enable_autocmd = false })
    end,
  },
}
