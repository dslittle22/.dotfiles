return {
  "ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")
    fzf.setup({
      fzf_opts = {
        ["--bind"] = "alt-right:forward-word,alt-left:backward-word",
      },
      files = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
        },
      },
      grep = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        },
      },
    })
    vim.keymap.set("n", "<leader>p", fzf.files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fr", function()
      fzf.live_grep({ resume = true })
    end, { desc = "Resume last grep" })
    vim.keymap.set("n", "<leader>fo", function()
      fzf.oldfiles({ cwd_only = true })
    end, { desc = "Recent files (oldfiles)" })
    vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })
  end,
}
