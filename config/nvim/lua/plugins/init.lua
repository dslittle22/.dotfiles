local plugins = {
  { "tpope/vim-surround" },
  { "tpope/vim-fugitive" },
  { 'lewis6991/gitsigns.nvim', opts = {} },

  {
    "EdenEast/nightfox.nvim",
    config = function() vim.cmd.colorscheme('nightfox') end
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}

if require("hubspot").is_hubspot() then
  for _, plugin in ipairs(require("hubspot.plugins")) do
    table.insert(plugins, plugin)
  end
end

return plugins
