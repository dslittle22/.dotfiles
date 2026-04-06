local plugins = {
  { "tpope/vim-surround" },
  { "tpope/vim-fugitive" },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
        end, { desc = "Next hunk" })
        map('n', '[c', function()
          if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
        end, { desc = "Prev hunk" })

        map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
        map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
          { desc = "Stage selection" })
        map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
          { desc = "Reset selection" })
        map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })

        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>hi', gs.preview_hunk_inline, { desc = "Preview hunk inline" })
        map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        map('n', '<leader>hd', gs.diffthis, { desc = "Diff against index" })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff against last commit" })

        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        map('n', '<leader>tw', gs.toggle_word_diff, { desc = "Toggle word diff" })

        map({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = "Select hunk" })
      end,
    },
  },

  {
    "EdenEast/nightfox.nvim",
    config = function() vim.cmd.colorscheme('nightfox') end
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "esmuellert/codediff.nvim",
        opts = {
          highlights = {
            line_insert = "#2d4745",
          },
        },
      },

      "ibhagwan/fzf-lua", -- optional
    },
    opts = {
      disable_context_highlighting = true,
    },
    cmd = { "Neogit", "CodeDiff" },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>",                 desc = "Neogit status" },
      { "<leader>gl", "<cmd>Neogit log<cr>",             desc = "Git log" },
      { "<leader>gd", "<cmd>CodeDiff master...HEAD<cr>", desc = "Diff against master" },
    }
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

  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = { message = false },
    keys = {
      { "<leader>gc", "<cmd>GitLink! current_branch<cr>", mode = { "n", "v" }, desc = "Open current branch" },
      { "<leader>gm", "<cmd>GitLink! default_branch<cr>", mode = { "n", "v" }, desc = "Open default branch" },
      { "<leader>gb", "<cmd>GitLink! blame<cr>",          mode = { "n", "v" }, desc = "Open blame url" },
    },
  },



}

return plugins
