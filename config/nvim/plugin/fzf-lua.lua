vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  'https://github.com/ibhagwan/fzf-lua'
})

require('fzf-lua').setup({
  keymap = {
    fzf = {
      true,
      ['ctrl-q'] = 'select-all+accept',
      ['ctrl-a'] = 'select-all',
    },
  },
  -- files = {
  --   fzf_opts = {
  --     ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-files-history',
  --   },
  -- },
  -- grep = {
  --   fzf_opts = {
  --     ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-grep-history',
  --   },
  -- },
})

vim.keymap.set('n', '<leader>p', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>f', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>b', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>zg', '<cmd>FzfLua global<cr>', { desc = '$: buffer, @: file symbol, #: workspace symbols' })
vim.keymap.set('n', '<leader>zh', '<cmd>FzfLua history<cr>', { desc = 'History' })
vim.keymap.set('n', '<leader>zu', '<cmd>FzfLua resume<cr>', { desc = 'Resume' })
vim.keymap.set('n', '<leader>zw', '<cmd>FzfLua grep_cword<cr>', { desc = 'grep word under cursor' })
vim.keymap.set('n', '<leader>zW', '<cmd>FzfLua grep_cWORD<cr>', { desc = 'grep Word under cursor' })
vim.keymap.set('n', '<leader>zb', '<cmd>FzfLua git_branches<cr>', { desc = 'Git branches' })
vim.keymap.set('n', '<leader>zo', '<cmd>FzfLua oldfiles cwd_only=true<cr>', { desc = 'Recent files (oldfiles)' })
vim.keymap.set('n', '<leader>zH', '<cmd>FzfLua helptags<cr>', { desc = 'Help tags' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set('n', '<leader>zr', function() require('fzf-lua').lsp_references() end, opts)
    vim.keymap.set('n', '<leader>df', function() require('fzf-lua').diagnostics_document() end, opts)
    vim.keymap.set('n', '<leader>dp', function() require('fzf-lua').diagnostics_workspace() end, opts)
    vim.keymap.set('n', '<leader>zR', function() require('dslittle22.pickers.buffer_references').pick() end,
      { desc = 'Buffer references (symbol under cursor)' })
  end,
})



vim.keymap.set('n', '<leader>zf', function()
  require('fzf-lua').live_grep({
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --fixed-strings -e'
  })
end, { desc = 'Live grep (fixed strings)' })
