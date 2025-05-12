return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		setup = {},
		config = function()
			require("neotest").setup({
				adapters = {

					require("rustaceanvim.neotest"),
				},
			})
			vim.keymap.set("n", "<leader>ntr", function()
				require("neotest").run.run()
			end)

			vim.keymap.set("n", "<leader>ntf", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end)

			vim.keymap.set("n", "<leader>nts", function()
				require("neotest").summary.toggle()
			end)
		end,
	},
}
