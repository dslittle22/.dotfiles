vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.ruler = true
vim.opt.visualbell = true
vim.opt.wrap = true
vim.opt.formatoptions = "tcqrn1"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = false
vim.opt.mouse = "a"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
vim.opt.scrolloff = 10

vim.opt.backspace = 'indent,eol,start'
vim.opt.history = 1000                 -- Store lots of command line history
vim.opt.undolevels = 1000              -- Undo levels
vim.opt.laststatus = 2                 -- Fix status bar
vim.opt.updatetime = 50       -- Faster completion
vim.opt.confirm = true        -- Raise a dialog for ops that would fail with unsaved changes

-- vim.schedule(function()
  -- vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
-- end)
