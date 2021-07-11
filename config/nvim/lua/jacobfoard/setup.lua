require("lspsaga").init_lsp_saga()
require("colorizer").setup()
require("lspkind").init()
require("nvim-autopairs").setup()
require("gitsigns").setup({
	signs = {
		add = { hl = "GitGutterAdd", text = "+" },
		change = { hl = "GitGutterChange", text = "~" },
		delete = { hl = "GitGutterDelete", text = "_" },
		topdelete = { hl = "GitGutterDelete", text = "‾" },
		changedelete = { hl = "GitGutterChange", text = "~" },
	},
})
require("nvim-treesitter.configs").setup({ rainbow = { enable = true } })
require("focus").setup({ cursorline = false })
-- require("spectre").setup({ replace_engine={ ['sed']={ cmd = "gsed", }, }, })
require("spectre").setup()
require("Navigator").setup({ auto_save = "current", disable_on_zoom = true })
require("todo-comments").setup()
require("which-key").setup({ triggers = { "<leader>", "g" } })
require("octo").setup()
require("crates").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
require("rust-tools").setup({
	server = {
		capabilities = capabilities,
	},
})
