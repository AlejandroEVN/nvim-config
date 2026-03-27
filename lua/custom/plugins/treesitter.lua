return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		tag = "0.10.0",
		pin = true,
		opts = {
			ensure_installed = {
				"typescript",
				"tsx",
				"javascript",
				"lua",
				"html",
				"css",
				"markdown",
				"prisma",
			},
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
