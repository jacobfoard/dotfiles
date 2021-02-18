local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {"go", "json"},
  },
  textobjects = {enable = true},
  indent = {enable = true},
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
}

local opt = vim.api.nvim_command
opt("set foldmethod=expr")
opt("set foldexpr=nvim_treesitter#foldexpr()")
opt("set foldlevelstart=20")
