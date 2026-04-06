local M = {}

local extensions = { "ts", "tsx", "js", "jsx" }
local test_suffixes = { "-test", ".test", ".spec" }

local function is_test_file(path)
	return path:match("/static/test/spec/") ~= nil
end

local function test_to_source_candidates(path)
	local root, rel = path:match("(.*/static/)test/spec/(.*)")
	if not root or not rel then return {} end

	local base
	for _, s in ipairs(test_suffixes) do
		base = rel:match("^(.*)" .. s:gsub("%.", "%%.") .. "%.[^.]+$")
		if base then break end
	end
	if not base then return {} end

	local candidates = {}
	for _, ext in ipairs(extensions) do
		candidates[#candidates + 1] = root .. "js/" .. base .. "." .. ext
	end
	return candidates
end

local function source_to_test_candidates(path)
	local root, rel = path:match("(.*/static/)js/(.*)")
	if not root or not rel then return {} end

	local base = rel:match("^(.*)%.[^.]+$")
	if not base then return {} end

	local candidates = {}
	for _, s in ipairs(test_suffixes) do
		for _, ext in ipairs(extensions) do
			candidates[#candidates + 1] = root .. "test/spec/" .. base .. s .. "." .. ext
		end
	end
	return candidates
end

local function find_existing(candidates)
	for _, path in ipairs(candidates) do
		if vim.uv.fs_stat(path) then return path end
	end
end

local function create_test_file(path)
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

	local rel = path:match("/static/test/spec/(.*)")
	local describe_name = rel
		:gsub("%-test%.[^.]+$", "")
		:gsub("%.test%.[^.]+$", "")
		:gsub("%.spec%.[^.]+$", "")

	vim.fn.writefile({
		'describe("' .. describe_name .. '", () => {',
		"  ",
		"});",
	}, path)
end

function M.toggle()
	local path = vim.fn.expand("%:p")

	if not path:match("/static/") then
		vim.notify("Not in a static/ project", vim.log.levels.WARN)
		return
	end

	local is_test = is_test_file(path)
	local candidates = is_test and test_to_source_candidates(path) or source_to_test_candidates(path)
	local existing = find_existing(candidates)

	if existing then
		vim.cmd.edit(existing)
		return
	end

	if is_test or #candidates == 0 then
		vim.notify("Corresponding file not found", vim.log.levels.WARN)
		return
	end

	local target = candidates[1]
	local display = target:match("/static/(.*)")

	vim.ui.select({ "Yes", "No" }, { prompt = "Create " .. display .. "?" }, function(choice)
		if choice == "Yes" then
			create_test_file(target)
			vim.cmd.edit(target)
		end
	end)
end

return M
