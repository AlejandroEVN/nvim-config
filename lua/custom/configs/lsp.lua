local getWidth = function(_, cols, _)
	return math.floor(cols * 0.95)
end

local getHeight = function(_, _, rows)
	return math.floor(rows * 0.95)
end

local apply_layout = function(fn)
	return function()
		fn({ layout_config = { width = getWidth, height = getHeight } })
	end
end

local builtin = require("telescope.builtin")

local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", apply_layout(builtin.lsp_references), "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", apply_layout(builtin.lsp_document_symbols), "[D]ocument [S]ymbols")
	nmap("<leader>ws", apply_layout(builtin.lsp_dynamic_workspace_symbols), "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

require("neodev").setup()

require("typescript-tools").setup({
	on_attach = on_attach,
	root_dir = require("lspconfig.util").root_pattern(".git"),
})

local mason_lspconfig = require("mason-lspconfig")

local servers = {
	clangd = {
		autostart = true,
		filetypes = { "c", "h" },
	},
	-- gopls = {},
	-- pyright = {},
	emmet_language_server = {
		autostart = false,
		filetypes = { "html", "vue" },
	},
	cssls = {
		filetypes = { "css", "scss", "less" },
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
		},
	},
	ast_grep = {
		autostart = true,
		filetypes = { "html" },
	},
	html = { filetypes = { "html", "twig", "hbs" } },
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				diagnostics = {
					globals = { "vim", "require", "pcall", "pairs" },
				},
				telemetry = { enable = false },
			},
		},
	},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

for server_name, config in pairs(servers) do
	vim.lsp.config[server_name] = {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = config.settings,
		root_dir = config.root_dir,
		filetypes = config.filetypes,
		autostart = config.autostart,
	}
end

vim.g.rustaceanvim = function()
	return {
		-- other rustacean settings. --
		server = {
			on_attach = on_attach,
		},
	}
end
