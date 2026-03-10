vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, opts)
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>df', require('fzf-lua').diagnostics_document, opts)
    vim.keymap.set('n', '<leader>dp', require('fzf-lua').diagnostics_workspace, opts)
  end,
})

local js_filetypes = { javascript = true, typescript = true, javascriptreact = true, typescriptreact = true }

local statement_types = {
  variable_declaration = true,
  expression_statement = true,
  return_statement = true,
  if_statement = true,
  for_statement = true,
  for_in_statement = true,
  while_statement = true,
  throw_statement = true,
  switch_statement = true,
  try_statement = true,
  export_statement = true,
  lexical_declaration = true,
}

vim.keymap.set("n", "<leader>z", function()
  if not js_filetypes[vim.bo.filetype] then
    return
  end
  local word = vim.fn.expand("<cword>")
  if word == "" then
    return
  end

  local node = vim.treesitter.get_node()
  if not node then
    return
  end

  while node and not statement_types[node:type()] do
    node = node:parent()
  end

  if not node then
    return
  end

  local start_row = node:start()
  local end_row = node:end_()
  local indent = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]:match("^(%s*)")
  local log_line = indent .. "console.log({ " .. word .. " })"
  vim.api.nvim_buf_set_lines(0, end_row + 1, end_row + 1, false, { log_line })
end, { desc = "console.log word under cursor" })
