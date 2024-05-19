return {
  {
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				go = { "goimports", "gofmt", "gotests", "golines" },
				lua = { "lua_ls", "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier" },
				vue = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- surround.vim
	"tpope/vim-surround",

	-- auto-pairs
	"cohama/lexima.vim",

	{
		"lukas-reineke/indent-blankline.nvim",
		-- See `:help indent_blankline.txt`
		main = "ibl",
		opts = {
			indent = {
				char = "",
				tab_char = "",
			},
			scope = { enabled = false },
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
	},
}