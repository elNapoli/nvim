-- ████████╗██████╗  █████╗ ███╗   ██╗ ██████╗███████╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗
-- ╚══██╔══╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝    ████╗  ██║██║   ██║██║████╗ ████║
--    ██║   ██████╔╝███████║██╔██╗ ██║██║     █████╗      ██╔██╗ ██║██║   ██║██║██╔████╔██║
--    ██║   ██╔══██╗██╔══██║██║╚██╗██║██║     ██╔══╝      ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
--    ██║   ██║  ██║██║  ██║██║ ╚████║╚██████╗███████╗    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
--    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
-- Professional Development Environment - Optimized & Scalable Architecture

-- ============================================================================
-- PERFORMANCE OPTIMIZATION
-- ============================================================================

-- Disable unnecessary providers for faster startup
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Set Python provider explicitly (optimized path)
vim.g.python3_host_prog = "/Users/elnapoli/.pyenv/versions/3.12.9/bin/python3.12"

-- ============================================================================
-- CORE CONFIGURATION LOADING
-- ============================================================================

-- Load core configurations in optimal order
require("config.options")  -- Vim options first
require("config.keymaps")  -- Global keymaps
require("config.autocmds") -- Autocommands

-- ============================================================================
-- PLUGIN MANAGER INITIALIZATION
-- ============================================================================

require("lazy_config")

-- ============================================================================
-- POST-INITIALIZATION HOOKS
-- ============================================================================

-- Performance monitoring (development only)
if vim.env.NVIM_PROFILE then
  require("config.utils").setup_profiling()
end
