return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Busca archivos en el directorio actual" })
			vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Busca un string en el directorio actual " })
			vim.keymap.set(
				"n",
				"<leader>fw",
				builtin.current_buffer_fuzzy_find,
				{ desc = "Buscas una palabra en el archivo actual " }
			)
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Abre el buffer actual" })
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Busca TODOS" })

			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Listar los Git commits " })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Lista los actuales cambios por archivo " })
			vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Lista todas las branchs con un log preview" })
			require("telescope").load_extension("ui-select")
		end,
	},
}
