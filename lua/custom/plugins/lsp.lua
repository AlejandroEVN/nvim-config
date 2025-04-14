return {
	{
		"pmizio/typescript-tools.nvim",
		opts = {},
		-- LSP Configuration & Plugins
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Automatically install LSPs to stdpath for neovim
			{
				"williamboman/mason.nvim",
				ensure_installed = {
					"eslint_d",
					"stylua",
					"jq",
					"prettierd",
				},
				config = true,
				lazy = false,
			},
			{ "williamboman/mason-lspconfig.nvim", lazy = false },

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = function()
			require("custom.configs.typescript-tools")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local ret = {
				servers = {
					rust_analyzer = {
						mason = false,
						settings = function() end,
					},
				},
				---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
				setup = {
					rust_analyzer = function()
						return true
					end,
				},
			}
			return ret
		end,
		config = function()
			require("custom.configs.lsp")
		end,
	},
}
