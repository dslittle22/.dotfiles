return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
  },
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    nes = {
      enabled = true,
      keymap = {
        accept_and_goto = "<tab>",
        dismiss = "<esc>",
      },
    },
  },
}
