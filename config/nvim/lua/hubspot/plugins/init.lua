-- Auto-require all .lua files in this directory
local dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h')
for _, file in ipairs(vim.fn.glob(dir .. '/*.lua', false, true)) do
  local mod = file:match('.*/lua/(.+)%.lua$'):gsub('/', '.')
  if mod ~= 'hubspot.plugins.init' then
    require(mod)
  end
end
