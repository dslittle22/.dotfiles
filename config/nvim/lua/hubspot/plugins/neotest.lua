vim.pack.add({
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  { src = 'https://github.com/HubSpotEngineering/neotest-hs-jasmine' },
  -- TODO: when neovim/neovim#37727 lands, use local path for development:
  -- { src = '~/src/neotest-hs-jasmine' },
})

-- Install runner dependencies on plugin install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'neotest-hs-jasmine' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.system({ 'yarn', '--cwd', ev.data.path .. '/runner', 'install' })
    end
  end,
})

require('neotest').setup({
  adapters = {
    require('neotest-hs-jasmine'),
  },
})

vim.keymap.set('n', '<leader>tn', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end,
  { desc = 'Run file tests' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open({ enter = true }) end,
  { desc = 'Test output' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Test summary' })
