return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Configurar keymaps cuando LSP se attache
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Configurar capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configurar signos de diagnóstico
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Configurar Mason con nombres correctos
		mason_lspconfig.setup({
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"volar", -- Nombre correcto en mason-lspconfig
			},
		})

		-- Configuraciones específicas por servidor
		local server_configs = {
			-- Vue Language Server (Volar)
			volar = {
				filetypes = { "vue" },
			},

			-- TypeScript con soporte para Vue
			ts_ls = {
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			},

			-- Svelte
			svelte = {
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							if client.name == "svelte" then
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end
						end,
					})
				end,
			},

			-- GraphQL
			graphql = {
				filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			},

			-- Emmet
			emmet_ls = {
				filetypes = {
					"vue",
					"html",
					"typescriptreact",
					"javascriptreact",
					"css",
					"sass",
					"scss",
					"less",
					"svelte",
				},
			},

			-- Lua
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							checkThirdParty = false,
						},
					},
				},
			},
		}

		-- Mapeo entre nombres de Mason y lspconfig
		local mason_to_lspconfig = {
			volar = "volar", -- Ambos usan el mismo nombre
			ts_ls = "ts_ls",
			html = "html",
			cssls = "cssls",
			svelte = "svelte",
			lua_ls = "lua_ls",
			graphql = "graphql",
			emmet_ls = "emmet_ls",
			prismals = "prismals",
			pyright = "pyright",
		}

		-- Configurar servidores instalados
		for _, mason_name in ipairs(mason_lspconfig.get_installed_servers()) do
			local lspconfig_name = mason_to_lspconfig[mason_name] or mason_name
			
			-- Obtener configuración específica o usar la por defecto
			local config = server_configs[lspconfig_name] or {}
			config.capabilities = capabilities

			-- Configurar el servidor si existe en lspconfig
			if lspconfig[lspconfig_name] then
				lspconfig[lspconfig_name].setup(config)
			else
				vim.notify("LSP server not found: " .. lspconfig_name, vim.log.levels.WARN)
			end
		end
	end,
}
