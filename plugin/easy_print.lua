local lang_log = {
	rs = 'println!("{:?}", %s);',
	ts = 'console.log("%s", %s);',
	lua = 'print("%s", %s)',
}

vim.keymap.set("n", "<leader>lw", function()
	local word = vim.fn.expand("<cword>")
	local ext = vim.fn.expand("%:e")

	local log_fmt = lang_log[ext]

	if not log_fmt then
		print("No configuration for current filetype: ." .. ext)
		return
	end

	local log_statement = string.format(log_fmt, word, word)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, line, line, false, { log_statement })
end, { desc = "[L]og [W]ord under cursor" })
