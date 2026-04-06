local source = {}

local cache = {}

local TRANSLATION_COMPONENTS = {
  FormattedMessage = true,
  FormattedHTMLMessage = true,
  FormattedJSXMessage = true,
  FormattedReactMessage = true,
}

local I18N_METHODS = {
  text = true,
  unescapedText = true,
}

local function is_translation_context(bufnr, row, col)
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col } })
  if not ok or not node then return false end

  local current = node
  while current do
    local t = current:type()
    local text = vim.treesitter.get_node_text(current, bufnr)

    if t == "call_expression" then
      local func = current:named_child(0)
      if not func then return false end
      local name = vim.treesitter.get_node_text(func, bufnr)
      -- I18n.text(), I18n.unescapedText(), text(), unescapedText()
      return I18N_METHODS[name] == true
        or I18N_METHODS[name:match("%.(%w+)$") or ""] == true
    end

    if t == "jsx_self_closing_element" or t == "jsx_opening_element" then
      local tag = current:named_child(0)
      if tag then return TRANSLATION_COMPONENTS[vim.treesitter.get_node_text(tag, bufnr)] == true end
      return false
    end

    current = current:parent()
  end
  return false
end

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  return self
end

function source:get_trigger_characters()
  return { '"', "'" }
end

local function find_git_root(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then return nil end

  local dir = vim.fn.fnamemodify(filepath, ":h")
  while dir ~= "/" do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

local function flatten_yaml(lines)
  local results = {}
  local stack = {}

  for _, line in ipairs(lines) do
    if line:match("^%s*#") or line:match("^%s*$") then
      goto continue
    end

    local indent = #(line:match("^(%s*)") or "")
    local key, value = line:match("^%s*([%w_%.%-]+):%s+(.+)$")

    if not key then
      key = line:match("^%s*([%w_%.%-]+):%s*$")
    end

    if key then
      while #stack > 0 and stack[#stack].indent >= indent do
        table.remove(stack)
      end

      if value and value ~= "" then
        local parts = {}
        for _, entry in ipairs(stack) do
          table.insert(parts, entry.key)
        end
        table.insert(parts, key)
        local full_key = table.concat(parts, ".")
        value = value:gsub("^[\"'](.+)[\"']$", "%1")
        results[full_key] = value
      else
        table.insert(stack, { key = key, indent = indent })
      end
    end

    ::continue::
  end

  return results
end

local function parse_lyaml_files(file_paths)
  local merged = {}

  for _, path in ipairs(file_paths) do
    local f = io.open(path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local lines = {}
      for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end
      local entries = flatten_yaml(lines)
      for k, v in pairs(entries) do
        merged[k] = v
      end
    end
  end

  local items = {}
  for key, value in pairs(merged) do
    key = key:gsub("^en%.", "")
    table.insert(items, {
      label = key,
      kind = require("blink.cmp.types").CompletionItemKind.Text,
      documentation = {
        kind = "markdown",
        value = value,
      },
    })
  end

  table.sort(items, function(a, b) return a.label < b.label end)
  return items
end

local EMPTY = { is_incomplete_forward = false, is_incomplete_backward = false, items = {} }

function source:get_completions(ctx, callback)
  callback = vim.schedule_wrap(callback)

  local bufnr = ctx.bufnr
  local row = ctx.cursor[1] - 1
  local col = ctx.cursor[2]

  if not is_translation_context(bufnr, row, col) then
    callback(EMPTY)
    return
  end
  local root = find_git_root(bufnr)

  if not root then
    callback(EMPTY)
    return
  end

  if cache[root] then
    callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = cache[root] })
    return
  end

  vim.system(
    { "rg", "--files", "-g", "*en.lyaml", root },
    { text = true },
    function(result)
      if result.code ~= 0 or result.stdout == "" then
        callback(EMPTY)
        return
      end

      local lyaml_files = vim.split(result.stdout, "\n", { trimempty = true })
      local items = parse_lyaml_files(lyaml_files)
      cache[root] = items
      callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
    end
  )
end

return source
