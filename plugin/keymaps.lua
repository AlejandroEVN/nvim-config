vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [D]iagnostics [L]ist" })

-- Quickfix 
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { noremap = true, silent = true, desc = "[Q]uickfix next" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { noremap = true, silent = true, desc = "[Q]uickfix previous" })
vim.keymap.set("n", "<leader>q", ":copen<CR>", { noremap = true, silent = true, desc = "Open [Q]uickfix" })

-- Oil
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, silent = true, desc = "Open Oil in CWD" })

-- Terminal
vim.keymap.set("t", "<esc>", "<C-\\><C-N>", { desc = "[T]erminal normal" })

-- Copy path
vim.keymap.set("n", "<leader>yp", function()
	vim.cmd('let @" = expand("%")')
end, { desc = "[Y]ank file [P]ath" })
