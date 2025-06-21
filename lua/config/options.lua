-- ============================================================================
-- VIM OPTIONS - PROFESSIONAL DEVELOPMENT CONFIGURATION
-- ============================================================================

local opt = vim.opt
local g = vim.g

-- ============================================================================
-- PERFORMANCE OPTIMIZATIONS
-- ============================================================================

opt.lazyredraw = true        -- Don't redraw while executing macros
opt.synmaxcol = 300         -- Limit syntax highlighting for long lines
opt.updatetime = 250        -- Faster completion and diagnostics
opt.timeoutlen = 300        -- Faster which-key popup
opt.ttimeoutlen = 10        -- Faster escape sequences

-- ============================================================================
-- UI AND VISUAL ENHANCEMENTS
-- ============================================================================

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- Visual indicators
opt.cursorline = true
opt.colorcolumn = "80,100"  -- Visual guide for line length
opt.signcolumn = "yes:2"    -- Always show sign column with space for 2 signs
opt.showmode = false        -- Don't show mode (lualine handles this)
opt.ruler = false           -- Don't show ruler (lualine handles this)

-- Scrolling and viewport
opt.scrolloff = 8           -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8       -- Keep 8 columns left/right of cursor
opt.wrap = false            -- No line wrapping
opt.linebreak = true        -- Break lines at word boundaries when wrap is on

-- Colors and themes
opt.termguicolors = true
opt.background = "dark"

-- ============================================================================
-- INDENTATION AND FORMATTING
-- ============================================================================

opt.tabstop = 4             -- Tab width
opt.shiftwidth = 4          -- Indent width
opt.softtabstop = 4         -- Tab key behavior
opt.expandtab = true        -- Use spaces instead of tabs
opt.autoindent = true       -- Copy indent from current line
opt.smartindent = true      -- Smart indentation for programming

-- ============================================================================
-- SEARCH AND REPLACE
-- ============================================================================

opt.ignorecase = true       -- Ignore case in search
opt.smartcase = true        -- Case sensitive if uppercase present
opt.hlsearch = true         -- Highlight search results
opt.incsearch = true        -- Incremental search
opt.gdefault = true         -- Use 'g' flag by default in substitutions

-- ============================================================================
-- FILE HANDLING
-- ============================================================================

opt.backup = false          -- No backup files
opt.writebackup = false     -- No backup while writing
opt.swapfile = false        -- No swap files
opt.undofile = true         -- Persistent undo
opt.undolevels = 1000      -- Undo history limit
opt.autoread = true         -- Auto-reload files changed outside vim
opt.hidden = true           -- Allow hidden buffers

-- ============================================================================
-- COMPLETION AND WILDCARDS
-- ============================================================================

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10          -- Popup menu height
opt.wildmode = { "longest:full", "full" }
opt.wildignore:append({
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/*",
  "*/node_modules/*", "*/.DS_Store"
})

-- ============================================================================
-- WINDOW AND BUFFER MANAGEMENT
-- ============================================================================

opt.splitright = true      -- Vertical splits open to the right
opt.splitbelow = true       -- Horizontal splits open below
opt.equalalways = false     -- Don't auto-resize windows

-- ============================================================================
-- CLIPBOARD AND MOUSE
-- ============================================================================

opt.clipboard:append("unnamedplus")  -- Use system clipboard
opt.mouse = "a"                      -- Enable mouse support

-- ============================================================================
-- FOLDING CONFIGURATION
-- ============================================================================

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- ============================================================================
-- SPECIAL CHARACTERS
-- ============================================================================

opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "▶",
  precedes = "◀"
}
opt.fillchars = {
  fold = " ",
  eob = " ",         -- Hide ~ at end of buffer
  vert = "│",
}

-- ============================================================================
-- NETRW CONFIGURATION (FILE EXPLORER)
-- ============================================================================

g.netrw_liststyle = 3       -- Tree style listing
g.netrw_browse_split = 0    -- Open files in the same window
g.netrw_altv = 1           -- Open splits to the right
g.netrw_winsize = 25       -- Set width to 25%

-- ============================================================================
-- DIAGNOSTIC CONFIGURATION
-- ============================================================================

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
    source = "if_many"
  },
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- ============================================================================
-- CUSTOM HIGHLIGHT GROUPS
-- ============================================================================

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Custom highlights for better visibility
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c4048" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#9ca0a4" })
  end,
})
