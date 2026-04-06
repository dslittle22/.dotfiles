vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.visualbell = true
vim.opt.wrap = true
vim.opt.formatoptions = "tcqrn1"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = false
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.opt.showmatch = true
vim.opt.wildmode = "list:longest,full"
vim.opt.scrolloff = 10

vim.keymap.set('n', '<BS>', '"_X')
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.updatetime = 50
vim.opt.confirm = true

vim.opt.grepprg = "rg --vimgrep --smart-case"
