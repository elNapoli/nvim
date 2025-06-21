return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble_telescope = require("trouble.sources.telescope")

		-- Crear una acción personalizada
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble_telescope.open()
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- mover a resultado anterior
						["<C-j>"] = actions.move_selection_next, -- mover al siguiente resultado
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		-- Establecer keymaps
		local keymap = vim.keymap -- para mayor claridad

		keymap.set(
			"n",
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			{ desc = "Buscar archivos en el directorio actual" }
		)
		keymap.set(
			"n",
			"<leader>fw",
			"<cmd>Telescope current_buffer_fuzzy_find<cr>",
			{ desc = "Buscar en vivo dentro del buffer actual" }
		)
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Buscar texto en el directorio actual" })
		keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Listar marcas de vim y su valor" })
		keymap.set(
			"n",
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "Buscar texto bajo el cursor en el directorio actual" }
		)
		keymap.set(
			"n",
			"<leader>fb",
			"<cmd>Telescope buffers<cr>",
			{ desc = "Listar buffers abiertos en la instancia actual de neovim" }
		)
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Buscar todos los TODOs" })
	end,
}
