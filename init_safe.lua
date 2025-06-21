-- ============================================================================
-- INIT.LUA TEMPORAL PARA DEBUGGING
-- ============================================================================

-- Desactivar providers innecesarios
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Python path
vim.g.python3_host_prog = "/Users/elnapoli/.pyenv/versions/3.12.9/bin/python3.12"

-- Cargar configuraciones básicas primero
require("config.options_safe")  -- Usar la versión segura
require("config.keymaps")
-- require("config.autocmds")  -- Comentado temporalmente

-- Plugin manager
require("lazy_config")
