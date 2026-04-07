if not require('hubspot').is_hubspot() then
  return
end

-- Install runner dependencies on plugin install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'neotest-hs-jasmine' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.system({ 'yarn', '--cwd', ev.data.path .. '/runner', 'install' })
    end
  end,
})

-- HubSpot-specific plugins
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nickjvandyke/opencode.nvim',
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  { src = 'https://github.com/HubSpotEngineering/neotest-hs-jasmine' },
  -- TODO: when neovim/neovim#37727 lands, use local path for development:
  -- { src = '~/src/neotest-hs-jasmine' },
  { src = 'git@github.com:HubSpotEngineering/bend.nvim.git' },
  -- Copilot
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/copilotlsp-nvim/copilot-lsp',
  'https://github.com/giuxtaposition/blink-cmp-copilot',
  'https://github.com/pmizio/typescript-tools.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})

-- Copilot setup
vim.g.copilot_nes_debounce = 500
require('copilot').setup({
  suggestion = { enabled = true },
  panel = { enabled = false },
  nes = { enabled = false },
})

local bend = require('bend')
bend.setup({ v2 = true })

require('typescript-tools').setup({
  single_file_support = false,
  root_dir = function(bufnr, on_dir)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if not bufname:match('^/') then
      return
    end
    on_dir(require('typescript-tools.utils').get_root_dir(bufnr))
  end,
  settings = {
    tsserver_path = bend.getTsServerPathForCurrentFile(),
    tsserver_plugins = {
      '@styled/typescript-styled-plugin',
    },
  },
})

-- ESLint LSP with auto-fix on save
local base_eslint_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    if base_eslint_on_attach then
      base_eslint_on_attach(client, bufnr)
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'LspEslintFixAll',
    })
  end,
})
vim.lsp.enable('eslint')

-- Opencode setup
local opencode_cmd = 'dvx opencode --port'
local opencode_term_opts = {
  split = 'right',
  width = math.floor(vim.o.columns * 0.35),
}

vim.g.opencode_opts = {
  server = {
    start = function()
      require('opencode.terminal').open(opencode_cmd, opencode_term_opts)
    end,
    stop = function()
      require('opencode.terminal').close(opencode_cmd, opencode_term_opts)
    end,
    toggle = function()
      require('opencode.terminal').toggle(opencode_cmd, opencode_term_opts)
    end,
  },
}
vim.o.autoread = true

-- Neotest setup
require('neotest').setup({
  adapters = {
    require('neotest-hs-jasmine'),
  },
})

-- Translation hover/go-to-definition keymaps
require('hubspot.blink-hs-translations').setup()

-- Keymaps: test_toggle and bend_picker
vim.keymap.set('n', '<leader>tt', require('hubspot.test_toggle').toggle, { desc = 'Toggle test/source file' })
vim.keymap.set('n', '<leader>wp', require('hubspot.bend_picker').pick, { desc = 'Pick bend workspace' })

-- Keymaps: opencode
vim.keymap.set('n', '<C-.>', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set({ 'n', 'v' }, '<C-a>', function() require('opencode').ask() end, { desc = 'Ask opencode' })
vim.keymap.set({ 'n', 'v' }, '<C-x>', function() require('opencode').select() end, { desc = 'Execute opencode action' })
vim.keymap.set({ 'n', 'v' }, 'go', function() return require('opencode').operator('@this ') end,
  { expr = true, desc = 'Add range to opencode' })
vim.keymap.set('n', 'goo', function() return require('opencode').operator('@this ') .. '_' end,
  { expr = true, desc = 'Add line to opencode' })
vim.keymap.set('n', '<S-C-u>', function() require('opencode').command('session.half.page.up') end,
  { desc = 'Scroll opencode up' })
vim.keymap.set('n', '<S-C-d>', function() require('opencode').command('session.half.page.down') end,
  { desc = 'Scroll opencode down' })
vim.keymap.set('n', '<C-q>', function() require('opencode.terminal').close(opencode_cmd, opencode_term_opts) end,
  { desc = 'Close opencode' })

-- Keymaps: neotest
vim.keymap.set('n', '<leader>tn', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end,
  { desc = 'Run file tests' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open({ enter = true }) end,
  { desc = 'Test output' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Test summary' })
