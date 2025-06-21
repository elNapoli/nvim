-- ============================================================================
-- CONFIGURACIÓN TEMPORAL SIMPLIFICADA
-- ============================================================================
-- Si hay errores, usa este archivo reemplazando config/options.lua

local opt = vim.opt

-- Configuraciones básicas y seguras
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

-- Indentación
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Archivos
opt.backup = false
opt.swapfile = false
opt.undofile = true

-- Ventanas
opt.splitright = true
opt.splitbelow = true

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Básico de folding (sin treesitter)
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Diagnósticos básicos
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})
