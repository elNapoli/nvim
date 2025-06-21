-- ============================================================================
-- CORE PLUGINS - ESSENTIAL FUNCTIONALITY
-- ============================================================================

return {
  -- ============================================================================
  -- PLENARY - UTILITY LIBRARY
  -- ============================================================================
  {
    "nvim-lua/plenary.nvim",
    lazy = false, -- Load immediately as many plugins depend on it
    priority = 1000,
  },

  -- ============================================================================
  -- TREESITTER - SYNTAX HIGHLIGHTING AND PARSING
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "css", "dockerfile", "go", "html", "javascript",
          "json", "lua", "markdown", "python", "rust", "typescript",
          "vim", "yaml", "vue", "svelte", "tsx", "scss"
        },
        
        auto_install = true,
        
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        
        indent = {
          enable = true,
        },
        
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
        },
      })
      
      -- Configure treesitter context
      require("treesitter-context").setup({
        enable = true,
        max_lines = 4,
        trim_scope = "outer",
        patterns = {
          default = {
            "class",
            "function",
            "method",
            "for",
            "while",
            "if",
            "switch",
            "case",
          },
        },
      })
    end,
  },

  -- ============================================================================
  -- TELESCOPE - FUZZY FINDER
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      "folke/todo-comments.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending",
          winblend = 0,
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")

      -- Set keymaps
      local keymap = vim.keymap
      keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", 
        { desc = "Find files in current directory" })
      keymap.set("n", "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>", 
        { desc = "Find in current buffer" })
      keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", 
        { desc = "Find text in current directory" })
      keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", 
        { desc = "Find text under cursor" })
      keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", 
        { desc = "List open buffers" })
      keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", 
        { desc = "Find help" })
      keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", 
        { desc = "Find recent files" })
      keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", 
        { desc = "Find todos" })
    end,
  },

  -- ============================================================================
  -- SESSION MANAGEMENT
  -- ============================================================================
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    config = function()
      local auto_session = require("auto-session")

      auto_session.setup({
        auto_restore_enabled = false,
        auto_session_suppress_dirs = { 
          "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" 
        },
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })

      local keymap = vim.keymap
      keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", 
        { desc = "Restore session for cwd" })
      keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", 
        { desc = "Save session for current working directory" })
      keymap.set("n", "<leader>wf", "<cmd>Telescope session-lens search_session<CR>", 
        { desc = "Find sessions" })
    end,
  },

  -- ============================================================================
  -- WHICH-KEY - KEYMAP HINTS
  -- ============================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        popup_mappings = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
      })

      -- Register leader key groups
      wk.register(vim.g.leader_groups or {}, { prefix = "<leader>" })
    end,
  },
}
