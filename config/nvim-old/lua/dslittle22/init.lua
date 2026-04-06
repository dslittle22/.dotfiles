vim.g.mapleader = " "
require("dslittle22.remap")
require("dslittle22.settings")
require("dslittle22.lazy")

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("ReloadConfig", { clear = true }),
  pattern = vim.fn.stdpath("config") .. "/lua/dslittle22/{settings,remap}.lua",
  callback = function(ev)
    vim.cmd("source " .. ev.file)
    vim.notify("Reloaded " .. vim.fs.basename(ev.file), vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})
