local plugins = {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("ts_context_commentstring").setup({ enable_autocmd = false })
		end,
	},
}

if require("hubspot").is_hubspot() then
	for _, plugin in ipairs(require("hubspot.plugins")) do
		table.insert(plugins, plugin)
	end
end

return plugins
