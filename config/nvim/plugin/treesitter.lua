vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/windwp/nvim-ts-autotag'
})

-- Auto-update parsers when plugin updates
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})

require('nvim-treesitter').install({ 'javascript', 'typescript', 'tsx', 'lua', 'vim', 'html', 'css', 'python' })

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      return
    end
    pcall(vim.treesitter.start) -- pcall in case no parser exists for this filetype
  end,
})

require('treesitter-context').setup({
  multiline_threshold = 10,
  trim_scope = 'outer',
  separator = '…',
})

require('nvim-ts-autotag').setup()
