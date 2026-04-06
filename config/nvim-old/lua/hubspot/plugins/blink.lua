return {
  "saghen/blink.cmp",
  dependencies = {
    "giuxtaposition/blink-cmp-copilot",
  },
  opts = {
    sources = {
      default = { "hs_translations", "copilot" },
      providers = {
        hs_translations = {
          name = "Translations",
          module = "blink-hs-translations",
          score_offset = -3,
          async = true,
        },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
  },
}
