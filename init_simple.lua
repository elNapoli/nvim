-- ============================================================================
-- INIT.LUA SIMPLIFICADO Y FUNCIONAL
-- ============================================================================

-- Optimizaciones básicas
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog = "/Users/elnapoli/.pyenv/versions/3.12.9/bin/python3.12"

-- Configuraciones básicas seguras
require("config.options_safe")
require("config.keymaps")

-- Plugin manager (versión segura)
require("lazy_config_safe")
