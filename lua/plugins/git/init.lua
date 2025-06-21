-- ============================================================================
-- GIT PLUGINS - VERSION CONTROL INTEGRATION
-- ============================================================================

return {
  -- ============================================================================
  -- GITSIGNS - GIT DECORATIONS
  -- ============================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then vim.cmd.normal({']c', bang = true})
            else gitsigns.nav_hunk('next') end
          end, { desc = "Next hunk" })
          map('n', '[c', function()
            if vim.wo.diff then vim.cmd.normal({'[c', bang = true})
            else gitsigns.nav_hunk('prev') end
          end, { desc = "Previous hunk" })

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Reset hunk" })
          map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "Stage buffer" })
          map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
          map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, { desc = "Blame line" })
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
          map('n', '<leader>hd', gitsigns.diffthis, { desc = "Diff this" })
          map('n', '<leader>td', gitsigns.toggle_deleted, { desc = "Toggle deleted" })
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
        end
      })
    end,
  },

  -- ============================================================================
  -- FUGITIVE - GIT COMMANDS
  -- ============================================================================
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git add current file" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
    },
  },

  -- ============================================================================
  -- LAZYGIT - TUI GIT CLIENT
  -- ============================================================================
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.9
    end,
  },
}
