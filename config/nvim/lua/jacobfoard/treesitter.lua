local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    -- disable = {"go", "json"},
  },
  textobjects = {enable = true},
  indent = {enable = true},
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
}

local opt = vim.api.nvim_command
local g = vim.g
opt("set foldmethod=expr")
opt("set foldexpr=nvim_treesitter#foldexpr()")
opt("set foldlevelstart=20")

g.indent_blankline_use_treesitter = true
g.indent_blankline_show_current_context = true
g.indent_blankline_context_patterns = {
  "class",
  "struct",
  "function",
  "arguments",
  "method",
  "^if",
  "^while",
  "^for",
  "^object",
  "^table",
  "block",
  "select",
}
g.indent_blankline_show_end_of_line = true
