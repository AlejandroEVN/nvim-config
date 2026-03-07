return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		tag = "v0.10.0",
		opts = {
			ensure_installed = {
				"typescript",
				"tsx",
				"javascript",
				"lua",
				"html",
				"css",
				"markdown",
				"markdown_inline",
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
