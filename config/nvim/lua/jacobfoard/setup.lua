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
require("spectre").setup()
require("Navigator").setup({ auto_save = "current", disable_on_zoom = true })
require("todo-comments").setup()
require("octo").setup()
require("crates").setup()
require("fidget").setup({})

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup({
    use_treesitter = true,
    show_current_context = true,
    -- show_current_context_start = true,
    show_end_of_line = true,
    space_char_blankline = " ",
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
