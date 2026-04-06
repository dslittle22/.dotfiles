-- opt-backspace = delete word 
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

vim.api.nvim_create_user_command('Svc', function()
  local dir = vim.fn.stdpath('config') .. '/lua/dslittle22'
  for _, file in ipairs({ 'remaps', 'settings' }) do
    vim.cmd('source ' .. dir .. '/' .. file .. '.lua')
  end
  vim.notify('Reloaded config')
end, {})
