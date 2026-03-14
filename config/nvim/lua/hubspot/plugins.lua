return {
  {
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
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    config = function()
      vim.lsp.enable("eslint")

      local base_on_attach = vim.lsp.config.eslint.on_attach
      vim.lsp.config("eslint", {
        on_attach = function(client, bufnr)
          if base_on_attach then
            base_on_attach(client, bufnr)
          end

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
          })
        end,
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- { url = "git@github.com:dalittle_hubspot/neotest-hs-jasmine.git", build = "cd runner && bend yarn" },
      { dir = "~/src/neotest-hs-jasmine" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-hs-jasmine"),
        },
      })
    end,
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end,                     desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run file tests" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Test summary" },
    },
  },
}
