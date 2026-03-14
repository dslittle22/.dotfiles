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
    vim.keymap.set("n", "<leader>f", fzf.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>zh", fzf.history, { desc = "History" })
    vim.keymap.set("n", "<leader>zr", fzf.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>zw", fzf.grep_cword, { desc = "grep word under cursor" })
    vim.keymap.set("n", "<leader>zW", fzf.grep_cWORD, { desc = "grep Word under cursor" })
    vim.keymap.set("n", "<leader>zb", fzf.git_branches)
    vim.keymap.set("n", "<leader>zo", function()
      fzf.oldfiles({ cwd_only = true })
    end, { desc = "Recent files (oldfiles)" })
    vim.keymap.set("n", "<leader>zH", fzf.helptags, { desc = "Help tags" })
  end,
}
