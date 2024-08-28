local augroup = vim.api.nvim_create_augroup("NoneLsFormatting", {})
local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end
end

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- lua
		null_ls.builtins.formatting.stylua,

		-- json
		require("none-ls.formatting.jq"),

		-- typescript
		require("none-ls.formatting.eslint_d"),
	},
	on_attach = on_attach,
})
