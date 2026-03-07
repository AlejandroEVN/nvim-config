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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_attach = function(client, bufnr)
	client.server_capabilities.semanticTokensProvider = nil

	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>ru", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { "source.removeUnusedImports.ts" },
				diagnostics = {},
			},
		})
	end, "[R]emove [U]nused Imports")
	nmap("<leader>ai", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { "source.addMissingImports.ts" },
				diagnostics = {},
			},
		})
	end, "[A]dd [M]issing Imports")
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", function()
		return builtin.lsp_references({ show_line = false })
	end, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", apply_layout(builtin.lsp_document_symbols), "[D]ocument [S]ymbols")
	nmap("<leader>ws", apply_layout(builtin.lsp_dynamic_workspace_symbols), "[W]orkspace [S]ymbols")
	nmap("K", function()
		vim.lsp.buf.hover({ border = "rounded", max_width = 80, max_height = 20 })
	end, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

local mason_lspconfig = require("mason-lspconfig")

local servers = {
	-- tsserver = {
	-- 	filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	-- },
	gopls = { autostart = false, filetypes = { "go" } },
	eslint = {
		autostart = true,
		filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		settings = {
			nodePath = ".yarn/sdks/eslint",
		},
	},
	prismals = {
		autostart = false,
		filetypes = { "prisma" },
	},
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

local orig_hover = vim.lsp.handlers.hover
vim.lsp.handlers.hover = function(err, result, ctx, config)
	if result and result.contents then
		if type(result.contents) == "table" and result.contents.value then
			local pad_x = "  "
			local pad_y = "\n"
			local lines = {}
			for line in result.contents.value:gmatch("([^\n]*)\n?") do
				table.insert(lines, pad_x .. line)
			end
			result.contents.value = pad_y .. table.concat(lines, "\n") .. pad_y
		end
	end
	orig_hover(err, result, ctx, config)
end

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = true,
})

for server_name, _ in pairs(servers) do
	vim.lsp.config(server_name, {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = (servers[server_name] or {}).settings,
		root_dir = (servers[server_name] or {}).root_dir,
		filetypes = (servers[server_name] or {}).filetypes,
		autostart = (servers[server_name] or {}).autostart,
	})
end
