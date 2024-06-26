vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

vim.keymap.set("n", "<C-a>", "<cmd>wqall!<CR>", { desc = "Guarda y cierra todo los archivos de vim" })
vim.keymap.set("n", "<C-x>", "<cmd>qall!<CR>", { desc = "Cierra todo los archivos de vim" })
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", { desc = "Cierra el archivo actual si no posee cambios" })
vim.keymap.set("n", "<C-s>", "<cmd>w!<CR>", { desc = "Save file!" })

vim.keymap.set("n", "<C-Up>", ":m .-2<CR>")
vim.keymap.set("n", "<C-RightMouse>", ":bnext<CR>")
vim.keymap.set("n", "<C-LeftMouse>", ":bprevious<CR>")
