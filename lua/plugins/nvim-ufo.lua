return {
	"kevinhwang91/nvim-ufo",
	dependencies = { 
		"kevinhwang91/promise-async",
		"neovim/nvim-lspconfig" -- Agregar dependencia explícita
	},
	event = "VeryLazy", -- Cargar después de que LSP esté listo
	config = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		-- Keymaps para folding
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		-- Configuración simple sin interferir con lspconfig
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
	end,
}
