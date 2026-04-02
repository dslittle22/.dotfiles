-- https://www.reddit.com/r/neovim/comments/1qfidjn/comment/o16u94p/
-- needed this to be abgle to set pathStrict = false, which per the above comment,
-- makes lazydev work correctly. And it needs to be in an lsp/ dir to be picked up.
return {
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = false,
      },
      workspace = {
        checkThirdParty = false,
        ignoreDir = {},
        library = { vim.env.VIMRUNTIME .. "/lua" },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
