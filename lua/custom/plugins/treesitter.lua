return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
		-- config = function()
		-- 	local ensure_installed =
		-- 		{ "lua", "python", "typescript", "c", "vim", "vimdoc", "query", "prisma", "markdown" }
		-- 	local installed = require("nvim-treesitter.config").get_installed()
		-- 	local to_install = vim.iter(ensure_installed)
		-- 		:filter(function(parser)
		-- 			return not vim.tbl_contains(installed, parser)
		-- 		end)
		-- 		:totable()
		-- 	if #to_install > 0 then
		-- 		require("nvim-treesitter").install(to_install)
		-- 	end
		-- end,
	},
}
