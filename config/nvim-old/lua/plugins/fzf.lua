return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>p",  "<cmd>FzfLua files<cr>",                  desc = "Find files" },
    { "<leader>f",  "<cmd>FzfLua live_grep<cr>",              desc = "Live grep" },
    { "<leader>b",  "<cmd>FzfLua buffers<cr>",                desc = "Buffers" },
    { "<leader>zg", "<cmd>FzfLua global<cr>",                 desc = "$: buffer, @: file symbol, #: workspace symbols" },
    { "<leader>zh", "<cmd>FzfLua history<cr>",                desc = "History" },
    { "<leader>zr", "<cmd>FzfLua resume<cr>",                 desc = "Resume" },
    { "<leader>zw", "<cmd>FzfLua grep_cword<cr>",             desc = "grep word under cursor" },
    { "<leader>zW", "<cmd>FzfLua grep_cWORD<cr>",             desc = "grep Word under cursor" },
    { "<leader>zb", "<cmd>FzfLua git_branches<cr>",           desc = "Git branches" },
    { "<leader>zo", "<cmd>FzfLua oldfiles cwd_only=true<cr>", desc = "Recent files (oldfiles)" },
    { "<leader>zH", "<cmd>FzfLua helptags<cr>",               desc = "Help tags" },
    vim.keymap.set("n", "<leader>zf", function()
      require("fzf-lua").live_grep({
        rg_opts =
        "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --fixed-strings -e"
      })
    end)
  },
  opts = {
    keymap = {
      fzf = {
        true,
        ["ctrl-q"] = "select-all+accept",
      },
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
  },
}
