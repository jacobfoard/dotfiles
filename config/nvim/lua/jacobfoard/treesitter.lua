local treesitter = require("nvim-treesitter.configs")
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.cue = {
    install_info = {
        url = "https://github.com/eonpatapon/tree-sitter-cue", -- local path or git repo
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
    },
    filetype = "cue", -- if filetype does not agrees with parser name
}

treesitter.setup({
    highlight = {
        enable = true, -- false will disable the whole extension
        -- disable = {"go", "json"},
    },
    -- textobjects = { enable = true },
    indent = { enable = true },
    ensure_installed = {
        "go",
        "nix",
        "json",
        "yaml",
        "cue",
    },
})

local opt = vim.api.nvim_command
opt("set foldmethod=expr")
opt("set foldexpr=nvim_treesitter#foldexpr()")
opt("set foldlevelstart=20")

-- local g = vim.g
-- g.indent_blankline_use_treesitter = true
-- g.indent_blankline_show_current_context = true
-- g.indent_blankline_context_patterns = {
-- 	"class",
-- 	"import_spec_list",
-- 	"call_expression",
-- 	"composite_literal",
-- 	"struct",
-- 	"function",
-- 	"arguments",
-- 	"method",
-- 	"^if",
-- 	"^while",
-- 	"^for",
-- 	"^object",
-- 	"^table",
-- 	"block",
-- 	"select",
-- }
-- g.indent_blankline_show_end_of_line = true
-- g.indent_blankline_char = "▏"
