-- ============================================================================
-- AUTOCOMMANDS - INTELLIGENT AUTOMATION
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- FILE TYPE SPECIFIC CONFIGURATIONS
-- ============================================================================

-- Programming Languages
autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "Set indentation for JS/TS files"
})

autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.colorcolumn = "88,100"  -- PEP 8 and black formatter
  end,
  desc = "Python specific settings"
})

autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false  -- Go uses tabs
  end,
  desc = "Go specific settings"
})

-- Configuration files
autocmd("FileType", {
  pattern = { "yaml", "yml", "json", "jsonc" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "YAML/JSON indentation"
})

-- ============================================================================
-- UI AND VISUAL ENHANCEMENTS
-- ============================================================================

-- Highlight on yank
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = highlight_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
  desc = "Highlight yanked text"
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function()
      vim.cmd([[%s/\s\+$//e]])
    end)
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace"
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Auto-resize splits on window resize"
})

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

-- Return to last edit position when opening files
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Return to last edit position"
})

-- Close certain filetypes with <q>
autocmd("FileType", {
  pattern = {
    "qf", "help", "man", "notify", "lspinfo", "spectre_panel",
    "startuptime", "tsplayground", "PlenaryTestPopup"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close with q"
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Reload file if changed outside of nvim"
})

-- ============================================================================
-- DEVELOPMENT WORKFLOW ENHANCEMENTS
-- ============================================================================

-- Auto-create directories on file save
autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create dir when saving a file"
})

-- Close quickfix menu after selecting choice
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = true, silent = true })
  end,
  desc = "Close quickfix after selection"
})

-- ============================================================================
-- TERMINAL CONFIGURATION
-- ============================================================================

-- Open terminal in insert mode
autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings"
})

-- ============================================================================
-- PERFORMANCE OPTIMIZATIONS
-- ============================================================================

-- Disable syntax highlighting for large files
autocmd("BufReadPre", {
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    if file_size > 512000 then -- 500KB
      vim.cmd("syntax off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = -1
    end
  end,
  desc = "Disable features for large files"
})

-- Disable certain features in very large files
autocmd("BufReadPre", {
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    if file_size > 1024000 then -- 1MB
      vim.opt_local.eventignore:append({
        "FileType",
        "Syntax",
        "BufEnter",
        "BufLeave",
        "BufWinEnter",
        "BufWinLeave",
        "BufNewFile",
        "BufRead",
      })
    end
  end,
  desc = "Disable events for very large files"
})

-- ============================================================================
-- GIT INTEGRATION
-- ============================================================================

-- Automatically refresh git signs when git files change
autocmd({ "BufWritePost", "BufEnter", "FocusGained" }, {
  pattern = "*",
  callback = function()
    if vim.fn.isdirectory(".git") == 1 then
      vim.schedule(function()
        if package.loaded["gitsigns"] then
          require("gitsigns").refresh()
        end
      end)
    end
  end,
  desc = "Refresh git signs"
})

-- ============================================================================
-- SESSION MANAGEMENT
-- ============================================================================

-- Auto-save session on exit (if auto-session is loaded)
autocmd("VimLeavePre", {
  callback = function()
    if package.loaded["auto-session"] then
      require("auto-session").SaveSession()
    end
  end,
  desc = "Auto-save session on exit"
})

-- ============================================================================
-- CUSTOM FILE TYPE DETECTION
-- ============================================================================

-- Set filetype for specific files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.env*",
    ".env*"
  },
  callback = function()
    vim.bo.filetype = "sh"
  end,
  desc = "Set filetype for env files"
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.conf",
    "*.config"
  },
  callback = function()
    vim.bo.filetype = "conf"
  end,
  desc = "Set filetype for config files"
})

-- Docker files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "Dockerfile*",
    "*.dockerfile",
    "docker-compose*.yml",
    "docker-compose*.yaml"
  },
  callback = function()
    if vim.fn.expand("%:t"):match("^Dockerfile") or vim.fn.expand("%"):match("%.dockerfile$") then
      vim.bo.filetype = "dockerfile"
    elseif vim.fn.expand("%:t"):match("^docker%-compose") then
      vim.bo.filetype = "yaml"
    end
  end,
  desc = "Set filetype for Docker files"
})

-- ============================================================================
-- MARKDOWN SPECIFIC
-- ============================================================================

autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
  desc = "Markdown specific settings"
})

-- ============================================================================
-- HELP FILES ENHANCEMENT
-- ============================================================================

autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.cmd("wincmd L") -- Open help in vertical split on the right
  end,
  desc = "Open help in vertical split"
})

-- ============================================================================
-- SMART BACKUP DIRECTORY CREATION
-- ============================================================================

autocmd("BufWritePre", {
  callback = function()
    local backup_dir = vim.fn.stdpath("state") .. "/backup"
    if vim.fn.isdirectory(backup_dir) == 0 then
      vim.fn.mkdir(backup_dir, "p")
    end
  end,
  desc = "Create backup directory if it doesn't exist"
})
