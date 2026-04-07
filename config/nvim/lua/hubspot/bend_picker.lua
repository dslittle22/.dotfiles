local M = {}

local skip_dirs = { static = true, target = true, node_modules = true }

local function dir_has_static_conf(dir)
  local root_conf = dir .. "/static_conf.json"
  if vim.fn.filereadable(root_conf) == 1 then return root_conf end

  local static_conf = dir .. "/static/static_conf.json"
  if vim.fn.filereadable(static_conf) == 1 then return static_conf end

  return nil
end

local function get_src_packages()
  local packages = {}
  local src = vim.fn.expand("~/src")

  for name, type in vim.fs.dir(src) do
    if type == "directory" and not skip_dirs[name] then
      local path = src .. "/" .. name
      if dir_has_static_conf(path) then packages[#packages + 1] = path end
      for sub, stype in vim.fs.dir(path) do
        if stype == "directory" and not skip_dirs[sub] then
          local subpath = path .. "/" .. sub
          if dir_has_static_conf(subpath) then packages[#packages + 1] = subpath end
        end
      end
    end
  end

  return packages
end

local freq_path = vim.fn.stdpath("data") .. "/bend_picker_freq.json"

local function read_freq()
  if vim.fn.filereadable(freq_path) == 0 then return {} end
  local content = vim.fn.readfile(freq_path)
  return vim.fn.json_decode(table.concat(content, ""))
end

local function write_freq(freq)
  vim.fn.writefile({ vim.fn.json_encode(freq) }, freq_path)
end

function M.pick()
  local packages = get_src_packages()
  local cwd = vim.fn.getcwd()
  local src_prefix = vim.fn.expand("~/src") .. "/"
  local freq = read_freq()

  -- Count packages under cwd for pre-selection
  local cwd_is_module = dir_has_static_conf(cwd)
  local cwd_package_count = 0
  for _, pkg in ipairs(packages) do
    if pkg == cwd or pkg:find(cwd .. "/", 1, true) == 1 then
      if cwd_is_module then
        if pkg == cwd then cwd_package_count = cwd_package_count + 1 end
      else
        cwd_package_count = cwd_package_count + 1
      end
    end
  end

  table.sort(packages, function(a, b)
    local a_match = a == cwd or a:find(cwd .. "/", 1, true) == 1
    local b_match = b == cwd or b:find(cwd .. "/", 1, true) == 1
    if a_match ~= b_match then return a_match end
    local a_freq = freq[a:sub(#src_prefix + 1)] or 0
    local b_freq = freq[b:sub(#src_prefix + 1)] or 0
    if a_freq ~= b_freq then return a_freq > b_freq end
    return a < b
  end)

  -- Build fzf bind to pre-select cwd packages
  local bind_actions = ""
  for i = 1, cwd_package_count do
    bind_actions = bind_actions .. "pos(" .. i .. ")+select+"
  end
  bind_actions = bind_actions .. "first"

  local display = vim.tbl_map(function(path) return path:sub(#src_prefix + 1) end, packages)

  require('fzf-lua').fzf_exec(display, {
    fzf_opts = {
      ['--multi'] = '',
      ['--preview'] = 'echo "$(wc -l < {+f} | tr -d " ") selected:" && echo "" && cat {+f}',
    },
    fzf_args = '--bind "load:' .. bind_actions .. '"',
    actions = {
      ['default'] = function(selected)
        local freq = read_freq()
        for _, pkg in ipairs(selected) do
          freq[pkg] = (freq[pkg] or 0) + 1
        end
        write_freq(freq)

        local full_paths = vim.tbl_map(function(path) return src_prefix .. path end, selected)
        vim.fn.setenv("BEND_DIRS", table.concat(full_paths, ":"))
        require("bend").reset()
      end,
    }
  })
end

return M
