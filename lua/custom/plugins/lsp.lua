return {
	{
		"pmizio/typescript-tools.nvim",
		opts = {},
		-- LSP Configuration & Plugins
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
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
}
