-- ============================================================================
-- GLOBAL KEYMAPS - CENTRALIZED MAPPING SYSTEM
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- CORE EDITING ENHANCEMENTS
-- ============================================================================

-- Quick escape from insert mode
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })

-- Better navigation in insert mode
keymap("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
keymap("i", "<C-j>", "<Down>", { desc = "Move down in insert mode" })
keymap("i", "<C-k>", "<Up>", { desc = "Move up in insert mode" })
keymap("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })

-- ============================================================================
-- ENHANCED FILE OPERATIONS
-- ============================================================================

-- File operations with safety checks
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<C-S-s>", "<cmd>wa<CR>", { desc = "Save all files" })

-- Smart quit operations
keymap("n", "<C-q>", function()
  if vim.bo.modified then
    vim.ui.input({
      prompt = "File has unsaved changes. Save before closing? (y/n/c): "
    }, function(input)
      if input == "y" then
        vim.cmd("wq")
      elseif input == "n" then
        vim.cmd("q!")
      end
    end)
  else
    vim.cmd("q")
  end
end, { desc = "Smart quit current buffer" })

keymap("n", "<C-A-q>", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- ============================================================================
-- ADVANCED TEXT MANIPULATION
-- ============================================================================

-- Line movement (enhanced)
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down (insert)" })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up (insert)" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate lines/selection
keymap("n", "<C-d>", "yyp", { desc = "Duplicate line" })
keymap("v", "<C-d>", "y'>p", { desc = "Duplicate selection" })

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ============================================================================
-- SEARCH AND REPLACE ENHANCEMENTS
-- ============================================================================

-- Clear search highlighting
keymap("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better search navigation
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Quick find and replace
keymap("n", "<leader>rr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", 
  { desc = "Replace word under cursor globally" })
keymap("v", "<leader>rr", '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', 
  { desc = "Replace selected text" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

-- Window splits
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Window navigation (enhanced)
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ============================================================================
-- TAB MANAGEMENT
-- ============================================================================

keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Close buffers intelligently
keymap("n", "<leader>bd", function()
  local buf_count = #vim.fn.getbufinfo({buflisted = 1})
  if buf_count > 1 then
    vim.cmd("bprevious")
    vim.cmd("bdelete #")
  else
    vim.cmd("enew")
    vim.cmd("bdelete #")
  end
end, { desc = "Delete buffer and switch to previous" })

keymap("n", "<leader>bD", "<cmd>%bdelete|edit#|bdelete#<CR>", 
  { desc = "Delete all buffers except current" })

-- ============================================================================
-- QUICKFIX AND LOCATION LIST
-- ============================================================================

keymap("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
keymap("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "<leader>qp", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })

keymap("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open location list" })
keymap("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close location list" })
keymap("n", "<leader>ln", "<cmd>lnext<CR>", { desc = "Next location item" })
keymap("n", "<leader>lp", "<cmd>lprevious<CR>", { desc = "Previous location item" })

-- ============================================================================
-- COMMAND LINE ENHANCEMENTS
-- ============================================================================

-- Command line navigation
keymap("c", "<C-h>", "<Left>", { desc = "Move left in command line" })
keymap("c", "<C-j>", "<Down>", { desc = "Move down in command line" })
keymap("c", "<C-k>", "<Up>", { desc = "Move up in command line" })
keymap("c", "<C-l>", "<Right>", { desc = "Move right in command line" })

-- Quick command line access
keymap("n", "<leader>;", ":", { desc = "Enter command mode" })
keymap("v", "<leader>;", ":", { desc = "Enter command mode" })

-- ============================================================================
-- CLIPBOARD ENHANCEMENTS
-- ============================================================================

-- System clipboard operations
keymap("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

keymap("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Paste without overwriting register
keymap("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- ============================================================================
-- DEVELOPMENT UTILITIES
-- ============================================================================

-- Toggle line numbers
keymap("n", "<leader>un", function()
  if vim.wo.number then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end, { desc = "Toggle line numbers" })

-- Toggle word wrap
keymap("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle word wrap" })

-- Toggle spell check
keymap("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle spell check" })

-- Terminal mode escape
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- LEADER KEY GROUPS (for which-key integration)
-- ============================================================================

-- These will be used by which-key for better organization
local leader_groups = {
  b = { name = "Buffer" },
  f = { name = "Find" },
  g = { name = "Git" },
  h = { name = "Hunk" },
  l = { name = "LSP/Lazy" },
  q = { name = "Quickfix" },
  r = { name = "Replace" },
  s = { name = "Split" },
  t = { name = "Tab/Toggle" },
  u = { name = "UI" },
  w = { name = "Workspace" },
  x = { name = "Diagnostics" },
}

-- Export for which-key configuration
vim.g.leader_groups = leader_groups
