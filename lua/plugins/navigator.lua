return {
	"ray-x/navigator.lua",
	requires = {
		{ "ray-x/guihua.lua", run = "cd lua/fzy && make" },
		{ "neovim/nvim-lspconfig" },
	},
	configuration = function()
		require("navigator").setup({})
	end,
}
