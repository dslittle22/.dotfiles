return {
  "neovim/nvim-lspconfig",
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  config = function()
    vim.lsp.enable("eslint")

    local base_on_attach = vim.lsp.config.eslint.on_attach
    vim.lsp.config("eslint", {
      on_attach = function(client, bufnr)
        if base_on_attach then
          base_on_attach(client, bufnr)
        end

        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "LspEslintFixAll",
        })
      end,
    })
  end,
}
