return {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    {
      url = "git@github.com:HubSpotEngineering/bend.nvim.git",
    },
  },
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  config = function()
    local bend = require("bend")
    bend.setup({ v2 = true })

    require("typescript-tools").setup({
      single_file_support = false,
      root_dir = function(bufnr, on_dir)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if not bufname:match("^/") then
          return
        end
        on_dir(require("typescript-tools.utils").get_root_dir(bufnr))
      end,
      settings = {
        tsserver_path = bend.getTsServerPathForCurrentFile(),
        tsserver_plugins = {
          -- for TypeScript v4.9+
          "@styled/typescript-styled-plugin",
          -- or for older TypeScript versions
          -- "typescript-styled-plugin",
        },
      },
    })
  end,
}
