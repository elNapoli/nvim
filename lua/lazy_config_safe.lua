-- ============================================================================
-- LAZY.NVIM CONFIGURATION - SAFE VERSION
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
  -- Import plugin configurations that exist
  { import = "plugins.core" },      -- Essential functionality
  { import = "plugins.editor" },    -- Editor enhancements
  { import = "plugins.ui" },        -- UI and theming
  { import = "plugins.lsp" },       -- Language server support
  { import = "plugins.git" },       -- Git integration
  { import = "plugins.debug" },     -- Debugging tools
  { import = "plugins.extras" },    -- Specialized tools
}, {
  install = {
    missing = true,
    colorscheme = { "catppuccin", "habamax" },
  },
  
  checker = {
    enabled = true,
    notify = false,
  },
  
  change_detection = {
    enabled = true,
    notify = false,
  },
  
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
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
    border = "rounded",
    size = {
      width = 0.8,
      height = 0.8,
    },
  },
})

-- ============================================================================
-- LAZY KEYMAPS
-- ============================================================================

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
