vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.visualbell = true
vim.opt.formatoptions = "tcqrn1"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.opt.showmatch = true
vim.opt.wildmode = "list:longest,full"
vim.opt.scrolloff = 10

vim.keymap.set('n', '<BS>', '"_X')
vim.opt.history = 1000
vim.opt.updatetime = 50
vim.opt.confirm = true

vim.opt.grepprg = "rg --vimgrep --smart-case"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"
vim.opt.foldlevel = 99

-- LSP folding (with treesitter fallback above)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
