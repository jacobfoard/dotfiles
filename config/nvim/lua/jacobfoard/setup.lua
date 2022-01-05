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
require("octo").setup()
require("crates").setup()

-- vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])
--
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup({
    use_treesitter = true,
    show_current_context = true,
    -- show_current_context_start = true,
    show_end_of_line = true,
    space_char_blankline = " ",
    -- char_highlight_list = {
    -- 	"IndentBlanklineIndent1",
    -- 	"IndentBlanklineIndent2",
    -- 	"IndentBlanklineIndent3",
    -- 	"IndentBlanklineIndent4",
    -- 	"IndentBlanklineIndent5",
    -- 	"IndentBlanklineIndent6",
    -- },
    context_patterns = {
        "class",
        "import_spec_list",
        "call_expression",
        "composite_literal",
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
    },
})
