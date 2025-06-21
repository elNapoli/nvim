-- ============================================================================
-- LAZY.NVIM CONFIGURATION - OPTIMIZED PLUGIN MANAGEMENT
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- LAZY CONFIGURATION
-- ============================================================================

require("lazy").setup({
  -- Import all plugin configurations
  { import = "plugins.core" },      -- Essential functionality
  { import = "plugins.editor" },    -- Editor enhancements
  { import = "plugins.ui" },        -- UI and theming
  { import = "plugins.lsp" },       -- Language server support
  { import = "plugins.git" },       -- Git integration
  { import = "plugins.debug" },     -- Debugging tools
  { import = "plugins.extras" },    -- Specialized tools
}, {
  -- ============================================================================
  -- LAZY SETTINGS
  -- ============================================================================
  
  install = {
    -- Install missing plugins on startup
    missing = true,
    -- Try to load one of these colorschemes when starting
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
  },
  
  checker = {
    -- Automatically check for plugin updates
    enabled = true,
    concurrency = 4,
    notify = false, -- Don't notify about updates
    frequency = 3600, -- Check every hour
  },
  
  change_detection = {
    -- Automatically reload when plugin files change
    enabled = true,
    notify = false, -- Don't notify about changes
  },
  
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- Reset packpath to improve startup time
    rtp = {
      -- Disable some rtp plugins for faster startup
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  
  ui = {
    -- Use a nice border for the lazy window
    border = "rounded",
    size = {
      width = 0.8,
      height = 0.8,
    },
    
    -- Custom icons
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  
  -- ============================================================================
  -- DEV SETTINGS (for plugin development)
  -- ============================================================================
  
  dev = {
    path = "~/projects",
    patterns = {}, -- For example: {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  
  -- ============================================================================
  -- DEBUG SETTINGS
  -- ============================================================================
  
  debug = false, -- Set to true for debug information
  
  -- ============================================================================
  -- PROFILING
  -- ============================================================================
  
  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    loader = false,
    -- Track each new require in the Lazy profiling tab
    require = false,
  },
})

-- ============================================================================
-- LAZY KEYMAPS
-- ============================================================================

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
vim.keymap.set("n", "<leader>lc", "<cmd>Lazy check<cr>", { desc = "Check for updates" })
vim.keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })
vim.keymap.set("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Profile startup" })
vim.keymap.set("n", "<leader>ld", "<cmd>Lazy debug<cr>", { desc = "Debug plugins" })

-- ============================================================================
-- POST-SETUP CONFIGURATION
-- ============================================================================

-- Set up autocommands for better lazy loading
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Load additional configurations that don't need to be loaded immediately
    require("config.utils")
  end,
})
