vim.api.nvim_create_user_command('Svc', function()
  local dir = vim.fn.stdpath('config') .. '/lua/dslittle22'
  for _, file in ipairs({ 'remap', 'settings', 'pickers' }) do
    vim.cmd('source ' .. dir .. '/' .. file .. '.lua')
  end
  vim.notify('Reloaded config')
end, {})

vim.keymap.set('i', '<M-BS>', '<C-w>')

-- Allow window navigation from terminal mode without needing to escape first
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Window nav from terminal mode" })
vim.keymap.set('n', '<C-b>', '<C-6>')

-- when in visual mode, J and K to move line up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- paste without deleting current buffer, by yanking selection to null register
vim.keymap.set("x", "<leader>v", "\"_dp")

-- leader + y (or Y) to yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', function() require('fzf-lua').lsp_references() end, opts)
    vim.keymap.set('n', 'gR', function() require('dslittle22.pickers').buffer_references() end, opts)
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>df', function() require('fzf-lua').diagnostics_document() end, opts)
    vim.keymap.set('n', '<leader>dp', function() require('fzf-lua').diagnostics_workspace() end, opts)
  end,
})

local js_filetypes = { javascript = true, typescript = true, javascriptreact = true, typescriptreact = true }

if require("hubspot").is_hubspot() then
  require("hubspot.remap")
end

vim.keymap.set("n", "<leader>/z", function()
  if not js_filetypes[vim.bo.filetype] then
    return
  end
  local word = vim.fn.expand("<cword>")
  if word == "" then
    return
  end

  vim.cmd("normal! }")
  local log_line = "console.log({ " .. word .. " })"
  vim.api.nvim_put({ log_line }, "l", true, true)
  vim.cmd("normal! ==")
end, { desc = "console.log word under cursor" })

vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", path)
  vim.notify(path)
end, { desc = "Copy relative file path" })

vim.keymap.set("n", "<leader>cl", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  local line = path .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", line)
  vim.notify(line)
end, { desc = "Copy relative file path with line number" })
