return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				go = { "goimports", "gofmt", "gotests", "golines" },
				lua = { "lua_ls", "stylua" },
				python = { "isort", "black" },
				vue = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				javascript = { "prettier", "prettierd" },
				rust = { "rustfmt", lsp_format = "fallback" },
				sql = { "sqlfmt", lsp_format = "fallback" },
				json = { "jq" },
				astro = { "prettier" },
				svelte = { "prettier" },
			},
			format_after_save = {
				timeout_ms = 5000,
				async = true,
			},
		},
	},
	-- Detect tabstop and shift
	-- width automatically
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
