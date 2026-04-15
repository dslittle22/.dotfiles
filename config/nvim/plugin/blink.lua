vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1' }
})

local is_hubspot = require('hubspot').is_hubspot()

local sources = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' }
local providers = {
  lazydev = {
    name = 'LazyDev',
    module = 'lazydev.integrations.blink',
    score_offset = 100,
  },
}

if is_hubspot then
  table.insert(sources, 1, 'hs_translations')
  table.insert(sources, 'copilot')
  providers.hs_translations = {
    name = 'Translations',
    module = 'hubspot.blink-hs-translations',
    score_offset = -3,
    async = true,
  }
  providers.copilot = {
    name = 'copilot',
    module = 'blink-cmp-copilot',
    score_offset = 100,
    async = true,
  }
end

require('blink.cmp').setup({
  enabled =
      function()
        local node = vim.treesitter.get_node()
        if node == nil then return true end
        return node:type():find('comment') == nil
      end,
  sources = {
    default = sources,
    providers = providers,
  },
  completion = {
    accept = { auto_brackets = { enabled = false } },
    documentation = { auto_show = true, auto_show_delay_ms = 1000 },
    ghost_text = {
      enabled = true, show_with_menu = false
    },
    menu = { auto_show = false }
  }
})
