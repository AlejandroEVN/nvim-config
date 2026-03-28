return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		},

		keys = {
			{
				"<leader>ds",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes, { border = "rounded" })
				end,
				desc = "[D]AP [S]copes",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover(nil, { border = "rounded" })
				end,
				desc = "[D]AP [H]over",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "[D]AP [C]ontinue",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "[D]AP Step [O]ver",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "[D]AP Step [I]nto",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "[D]AP Step [O]ut",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "[D]AP [B]reakpoint",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "[D]AP [R]EPL",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "[D]AP conditional breakpoint",
			},
			{ "<leader>da", "<cmd>AtoDebugAttach<cr>", desc = "[D]AP [A]ttach to MS" },
		},

		config = function()
			local dap = require("dap")

			-- Register the adapter directly (no bridge plugin needed)
			local js_debug_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/dapDebugServer.js"
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { js_debug_path, "${port}" },
				},
			}

			local supported_services = {
				"accounts",
				"courses",
				"emails",
				"learning",
				"mocks",
				"pdf",
				"questions",
				"schools",
				"sockets",
				"subscriptions",
			}

			local function ensure_debug_nodeport(service)
				local svc_name = "ato-debugger-" .. service

				local check = vim.fn.system(
					string.format("kubectl get svc %s -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null", svc_name)
				)
				local existing_port = tonumber(check)
				if existing_port then
					return existing_port
				end

				vim.fn.system(string.format("ato debugger %s 2>/dev/null", service:gsub("^ms%-", "")))

				local result =
					vim.fn.system(string.format("kubectl get svc %s -o jsonpath='{.spec.ports[0].nodePort}'", svc_name))
				local port = tonumber(result)
				if not port then
					vim.notify("Failed to get NodePort for " .. svc_name .. ": " .. result, vim.log.levels.ERROR)
					return nil
				end
				return port
			end

			dap.configurations.typescript = dap.configurations.typescript or {}

			vim.api.nvim_create_user_command("AtoDebugAttach", function()
				vim.ui.select(supported_services, { prompt = "Select microservice:" }, function(choice)
					if not choice then
						return
					end

					local full_name = "ms-" .. choice

					vim.notify("Exposing debug port for " .. full_name .. "...", vim.log.levels.INFO)
					local node_port = ensure_debug_nodeport(full_name)
					if not node_port then
						return
					end

					vim.notify(
						string.format("Attaching to %s on kubernetes:%d", full_name, node_port),
						vim.log.levels.INFO
					)

					-- Workspace root (git root)
					local ws = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+$", "")

					local svc_root = ws .. "/microservices/" .. full_name

					dap.run({
						type = "pwa-node",
						request = "attach",
						name = "Ato debugger - " .. full_name,
						address = "kubernetes",
						port = node_port,
						cwd = svc_root,
						sourceMaps = true,
						outFiles = { svc_root .. "/dist/**/*.js" },
						resolveSourceMapLocations = {
							svc_root .. "/dist/**/*.js",
							svc_root .. "/src/**/*.ts",
							"!**/node_modules/**",
						},
						sourceMapPathOverrides = {
							[svc_root .. "/dist/*"] = svc_root .. "/src/*",
						},
						restart = true,
						skipFiles = { "<node_internals>/**", "**/node_modules/**" },
						trace = {
							logFile = "/tmp/dap-trace.json",
						},
					})
				end)
			end, { desc = "Attach debugger to an ato microservice" })
		end,
	},
}
