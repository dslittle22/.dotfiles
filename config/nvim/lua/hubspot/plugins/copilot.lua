vim.pack.add({
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/copilotlsp-nvim/copilot-lsp',
  'https://github.com/giuxtaposition/blink-cmp-copilot',
})

vim.g.copilot_nes_debounce = 500
require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  nes = {
    enabled = true, -- requires copilot-lsp as a dependency
    -- auto_trigger = false,
    keymap = {
      accept_and_goto = "<leader><Tab>",
      accept = false,
      dismiss = "<Esc>",
    },
  },
})
