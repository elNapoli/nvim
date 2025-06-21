return {
	{
		"kevinhwang91/rnvimr",
		cmd = "RnvimrToggle",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- Required global variables (must set before calling the command)
			vim.g.rnvimr_draw_border = 1 -- rounded border
			vim.g.rnvimr_pick_enable = 1 -- allow file picking
			vim.g.rnvimr_bw_enable = 1 -- sync with current tab
		end,
	},
}
