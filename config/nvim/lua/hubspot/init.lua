local M = {}

function M.is_hubspot()
	return vim.env.USER == "dalittle"
end

return M
