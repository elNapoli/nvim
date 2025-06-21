-- ============================================================================
-- LSP PLUGINS - LANGUAGE SERVER PROTOCOL
-- ============================================================================

return {
  -- ============================================================================
  -- MASON - LSP INSTALLER
  -- ============================================================================
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_tool_installer = require("mason-tool-installer")

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
          border = "rounded",
          width = 0.8,
          height = 0.9,
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          -- LSP Servers
          "typescript-language-server",
          "html-lsp",
          "css-lsp",
          "tailwindcss-language-server",
          "svelte-language-server",
          "lua-language-server",
          "graphql-language-service-cli",
          "emmet-ls",
          "prisma-language-server",
          "pyright",
          "vue-language-server",
          "json-lsp",
          "yaml-language-server",
          "marksman",
          "bash-language-server",

          -- Formatters
          "prettier",
          "stylua",
          "isort",
          "black",
          "shfmt",

          -- Linters
          "eslint_d",
          "pylint",
          "shellcheck",
          "markdownlint",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 5,
      })
    end,
  },

  -- ============================================================================
  -- LSP CONFIG
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
      "b0o/schemastore.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local keymap = vim.keymap

      -- Configure keymaps when LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Buffer local mappings
          local opts = { buffer = ev.buf, silent = true }

          -- Navigation
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

          -- Actions
          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          -- Diagnostics
          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          -- Documentation
          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts)

          -- Workspace
          opts.desc = "Add workspace folder"
          keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)

          opts.desc = "Remove workspace folder"
          keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

          opts.desc = "List workspace folders"
          keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)

          -- Restart LSP
          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        end,
      })

      -- Configure capabilities
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Enhanced capabilities
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      -- Configure diagnostic signs
      local signs = { 
        Error = " ", 
        Warn = " ", 
        Hint = "󰠠 ", 
        Info = " " 
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Server configurations
      local server_configs = {
        -- TypeScript/JavaScript
        ts_ls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Vue
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
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

        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },

        -- TailwindCSS
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        },

        -- HTML
        html = {
          filetypes = { "html" },
        },

        -- GraphQL
        graphql = {
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        },

        -- Emmet
        emmet_ls = {
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "vue",
            "svelte",
          },
        },

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
              },
            },
          },
        },

        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        -- Markdown
        marksman = {},

        -- Bash
        bashls = {
          filetypes = { "sh", "zsh" },
        },
      }

      -- Setup mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(server_configs),
        automatic_installation = true,
      })

      -- Setup servers
      mason_lspconfig.setup_handlers({
        -- Default handler
        function(server_name)
          local config = server_configs[server_name] or {}
          config.capabilities = capabilities
          lspconfig[server_name].setup(config)
        end,

        -- Specific handlers
        ["lua_ls"] = function()
          local config = server_configs.lua_ls
          config.capabilities = capabilities
          lspconfig.lua_ls.setup(config)
        end,

        ["ts_ls"] = function()
          local config = server_configs.ts_ls
          config.capabilities = capabilities
          lspconfig.ts_ls.setup(config)
        end,
      })
    end,
  },

  -- ============================================================================
  -- FORMATTING - CONFORM
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          liquid = { "prettier" },
          vue = { "prettier" },
          lua = { "stylua" },
          python = { "isort", "black" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
        },
        
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
        
        formatters = {
          prettier = {
            prepend_args = { "--single-quote", "--jsx-single-quote" },
          },
          stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
        },
      })

      -- Format keymap
      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },

  -- ============================================================================
  -- SCHEMA STORE
  -- ============================================================================
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- ============================================================================
  -- NEODEV - LUA DEVELOPMENT
  -- ============================================================================
  {
    "folke/neodev.nvim",
    ft = "lua",
    opts = {
      library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true,
      },
      setup_jsonls = true,
      lspconfig = true,
      pathStrict = true,
    },
  },
}
