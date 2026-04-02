return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  opts = {
    keymap = { preset = 'enter' },
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      accept = { auto_brackets = { enabled = false } },
      documentation = { auto_show = true },
      ghost_text = { enabled = true },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    snippets = {
      extended_filetypes = { typescriptreact = { 'typescript' } },
    },
    signature = { enabled = true }
  },
  opts_extend = { "sources.default" }
}
