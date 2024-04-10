vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.wo.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
-- Navigate vim panes better
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Hace que los Splits tengan el mismo tamaño" })
vim.keymap.set("n", "<leader>sc", "<C-w>c", { desc = "cierra el Split acutal " })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = " Abre un nuevo Tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Cierra el Tab actual" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabNext<CR>", { desc = "Abres el Tab siguiente " })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Abres el Tab anterior" })


vim.keymap.set("n", "<C-a>", "<cmd>wqall!<CR>", { desc = "Guarda y cierra todo los archivos de vim" })

