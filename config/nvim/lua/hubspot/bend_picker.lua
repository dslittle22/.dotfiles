local log = require("vim.lsp.log")

local M = {}

local skip_dirs = { static = true, target = true, node_modules = true }

local function dir_has_static_conf(dir)
  local root_static_conf = dir .. "/static_conf.json"
  local static_folder_conf = dir .. "/static/static_conf.json"

  if vim.fn.filereadable(root_static_conf) == 1 then
    log.info("bend", "Found static_conf.json at project root: " .. root_static_conf)
    return root_static_conf
  elseif vim.fn.filereadable(static_folder_conf) == 1 then
    log.info("bend", "Found static_conf.json in /static folder: " .. static_folder_conf)
    return static_folder_conf
  end

  return nil
end

local function scandir_repeat_with_each(path, cb)
  local handle = vim.uv.fs_scandir(path)
  if handle then
    while true do
      local name, type = vim.uv.fs_scandir_next(handle)
      if not name then break end
      cb(name, type)
    end
  end
end

local function get_src_packages()
  local packages = {}
  local src_path = vim.fn.expand("~/src")

  local function check_subdir_for_static_conf(path)
    scandir_repeat_with_each(path, function(name, type)
      if (type ~= "directory") then return end
      if skip_dirs[name] then return end
      local full_module_path = path .. "/" .. name
      if (not dir_has_static_conf(full_module_path)) then return end
      table.insert(packages, full_module_path)
    end
    )
  end

  local function add_module_path_and_check_subdirs(name, type)
    if (type ~= "directory") then return end
    if skip_dirs[name] then return end
    local full_module_path = src_path .. "/" .. name
    if (not dir_has_static_conf(full_module_path)) then return end
    table.insert(packages, full_module_path)
    check_subdir_for_static_conf(full_module_path)
  end

  scandir_repeat_with_each(src_path, add_module_path_and_check_subdirs)
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

local function strip_prefix(string, prefix)
  return string:sub(#prefix + 1)
end

local function map(list, cb)
  local transformed = {}

  for _, item in ipairs(list) do
    table.insert(transformed, cb(item))
  end

  return transformed
end

function M.test()
  local packages = get_src_packages()


  local cwd = vim.fn.getcwd()
  local cwd_package_count = 0

  local cwd_is_module_path = dir_has_static_conf(cwd)

  for _, pkg in ipairs(packages) do
    if pkg == cwd or pkg:find(cwd .. "/", 1, true) == 1 then
      if cwd_is_module_path then
        if pkg == cwd then cwd_package_count = cwd_package_count + 1 end
      else
        cwd_package_count = cwd_package_count + 1
      end
    end
  end

  local src_prefix = vim.fn.expand("~/src") .. "/"
  local freq = read_freq()

  table.sort(packages, function(a, b)
    local a_match = a == cwd or a:find(cwd .. "/", 1, true) == 1
    local b_match = b == cwd or b:find(cwd .. "/", 1, true) == 1
    if a_match ~= b_match then return a_match end
    local a_freq = freq[strip_prefix(a, src_prefix)] or 0
    local b_freq = freq[strip_prefix(b, src_prefix)] or 0
    if a_freq ~= b_freq then return a_freq > b_freq end
    return a < b
  end)


  local bind_actions = ""
  for i = 1, cwd_package_count do
    bind_actions = bind_actions .. "pos(" .. i .. ")+select+"
  end
  bind_actions = bind_actions .. "first"


  require('fzf-lua').fzf_exec(map(packages, (function(path)
    return strip_prefix(path, vim.fn.expand("~/src/"))
  end)), {
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

        local full_paths = map(selected, (function(path)
          return vim.fn.expand("~/src/") .. path
        end))

        vim.fn.setenv("BEND_DIRS", table.concat(full_paths, ":"))
        require("bend").reset()
        -- vim.cmd("edit " .. vim.api.nvim_buf_get_name(0))
      end,
    }
  })
end

return M
