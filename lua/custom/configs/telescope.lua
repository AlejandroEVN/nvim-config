local getWidth = function(_, cols, _)
	return math.floor(cols * 0.95)
end

local getHeight = function(_, _, rows)
	return math.floor(rows * 0.95)
end

local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		live_grep_args = {
			auto_quoting = true,
			mappings = {
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					["<C-space>"] = lga_actions.to_fuzzy_refine,
				},
			},
		},
	},
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "live_grep_args")

local builtin = require("telescope.builtin")

local apply_layout = function(fn)
	return function()
		fn({ layout_config = { width = getWidth, height = getHeight } })
	end
end

vim.keymap.set("n", "<leader>sh", apply_layout(builtin.help_tags), { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", apply_layout(builtin.keymaps), { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", apply_layout(builtin.find_files), { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", apply_layout(builtin.builtin), { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>fl", apply_layout(builtin.lsp_document_symbols), { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", apply_layout(builtin.grep_string), { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sd", apply_layout(builtin.diagnostics), { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", apply_layout(builtin.resume), { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", apply_layout(builtin.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", apply_layout(builtin.buffers), { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>?", apply_layout(builtin.oldfiles), { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>sg", apply_layout(telescope.extensions.live_grep_args.live_grep_args), {
	desc = "[S]earch by [G]rep",
})

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })
