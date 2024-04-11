return {
	"kdheepak/lazygit.nvim",
	config = function()
		local lazygit = require("lazy").setup({
			{
				cmd = {
					"LazyGit",
					"LazyGitConfig",
					"LazyGitCurrentFile",
					"LazyGitFilter",
					"LazyGitFilterCurrentFile",
				},
				-- optional for floating window border decoration
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				-- setting the keybinding for LazyGit with 'keys' is recommended in
				-- order to load the plugin when the command is run for the first time
			},
		})

		vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "GIT UI " })
	end,
}
