vim.pack.add({
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/copilotlsp-nvim/copilot-lsp',
  'https://github.com/giuxtaposition/blink-cmp-copilot',
})

vim.g.copilot_nes_debounce = 500
require('copilot').setup({
  suggestion = { enabled = true },
  panel = { enabled = false },
  nes = { enabled = false },
})
