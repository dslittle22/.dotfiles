vim.pack.add({
  'https://github.com/nickjvandyke/opencode.nvim',
})

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
