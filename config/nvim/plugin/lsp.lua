vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/pmizio/typescript-tools.nvim',
  'https://github.com/folke/lazydev.nvim',
})

require('mason').setup()

-- typescript-tools is configured in hubspot.lua for HubSpot, with bend integration
if not require('hubspot').is_hubspot() then
  require('typescript-tools').setup({})
end

require('lazydev').setup()

vim.lsp.enable('lua_ls')

vim.diagnostic.config({
  virtual_text = true,
})
