return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
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
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
		},
		config = function()
			require("custom.configs.ts_ls")
		end,
	},
}
