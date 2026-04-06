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
    module = 'blink-hs-translations',
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
  sources = {
    default = sources,
    providers = providers,
  },
  completion = {
    accept = { auto_brackets = { enabled = false } },
    documentation = { auto_show = true },
  }
})
