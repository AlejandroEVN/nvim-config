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
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

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
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

return {
	{
		"pmizio/typescript-tools.nvim",
		opts = {},
		-- LSP Configuration & Plugins
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true, lazy = false },
			{ "williamboman/mason-lspconfig.nvim", lazy = false },

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = function()
			require("neodev").setup()
			require("typescript-tools").setup({
				on_attach = on_attach,
				root_dir = require("lspconfig.util").root_pattern(".git")
			})
			local mason_lspconfig = require("mason-lspconfig")

			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
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

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = (servers[server_name] or {}).settings,
						root_dir = (servers[server_name] or {}).root_dir,
						filetypes = (servers[server_name] or {}).filetypes,
						autostart = (servers[server_name] or {}).autostart,
					})
				end,
			})
			--[[
	lsp.tsserver.setup({
		init_options = {
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
					languages = { "typescript", "vue" },
				},
			},
		},
	}) ]]
		end,
	},
}
