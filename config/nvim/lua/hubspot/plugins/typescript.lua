vim.pack.add({
  { src = 'git@github.com:HubSpotEngineering/bend.nvim.git' },
  'https://github.com/pmizio/typescript-tools.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})

local bend = require('bend')
bend.setup({ v2 = true })

require('typescript-tools').setup({
  single_file_support = false,
  root_dir = function(bufnr, on_dir)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if not bufname:match('^/') then
      return
    end
    on_dir(require('typescript-tools.utils').get_root_dir(bufnr))
  end,
  settings = {
    tsserver_path = bend.getTsServerPathForCurrentFile(),
    tsserver_plugins = {
      '@styled/typescript-styled-plugin',
    },
  },
})

-- ESLint LSP with auto-fix on save
local base_eslint_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    if base_eslint_on_attach then
      base_eslint_on_attach(client, bufnr)
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'LspEslintFixAll',
    })
  end,
})
vim.lsp.enable('eslint')
