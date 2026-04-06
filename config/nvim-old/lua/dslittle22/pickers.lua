local M = {}

function M.buffer_references()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  vim.lsp.buf_request(0, 'textDocument/documentHighlight', params, function(err, result)
    if err or not result or #result == 0 then
      vim.notify('No references in buffer', vim.log.levels.INFO)
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local entries = {}
    for _, hl in ipairs(result) do
      local lnum = hl.range.start.line + 1
      local col = hl.range.start.character + 1
      table.insert(entries, string.format('%s:%d:%d: %s', filename, lnum, col, lines[lnum] or ''))
    end

    vim.schedule(function()
      require('fzf-lua').fzf_exec(entries, {
        actions = require('fzf-lua').defaults.actions.files,
        previewer = 'builtin',
      })
    end)
  end)
end

return M
