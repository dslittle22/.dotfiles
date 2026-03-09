local M = {}

function M.is_hubspot()
	return vim.loop.os_getenv("USER") == "dalittle"
end

return M
