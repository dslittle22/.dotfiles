return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter").install({ "javascript", "typescript", "tsx", "lua", "vim", "html", "python", "css" })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function() pcall(vim.treesitter.start) end,
      })
      -- experimental ts-based indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      multiline_threshold = 10, -- Maximum number of lines to show for a single context
    }
  },

  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
      })
      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
    end,
  }
}
