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
				typescript = { "oxfmt" },
				typescriptreact = { "oxfmt" },
				javascript = { "oxfmt" },
				json = { "jq" },
			},
			format_after_save = {
				timeout_ms = 5000,
				async = true,
			},
			formatters = {
				---@type conform.FormatterConfigOverride
				prettierd = {
					command = function(self, bufnr)
						local util = require("conform.util")
						local fs = require("conform.fs")
						local cmd = util.find_executable({ "~/.config/nvim/utils/prettier-nvim/bin/prettier.cjs" }, "")(
							self,
							bufnr
						)
						if cmd ~= "" then
							return cmd
						end
						-- return type of util.from_node_modules is fun(self: conform.FormatterConfig, ctx: conform.Context): string
						---@diagnostic disable-next-line
						return util.from_node_modules(fs.is_windows and "prettier.cmd" or "prettier")(self, bufnr)
					end,
				},
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
