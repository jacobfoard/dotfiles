vim.g.UltiSnipsExpandTrigger = "<c-q>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-e>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-3>"

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")

cmp.setup({
    experimental = {
        ghost_text = {},
    },
    formatting = {
        format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lsp = "[LSP]",
                vsnip = "[VSnip]",
                nvim_lua = "[Lua]",
                copilot = "[Copilot]",
            },
        }),
    },
    sources = cmp.config.sources({
        { name = "vsnip", keyword_length = 2 },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "vim-dadbod-completion" },
        { name = "crates" },
        { name = "bazel" },
        { name = "copilot" },
    }),
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.complete(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = function()
            if vim.fn.pumvisible() ~= 0 then
                cmp.select_prev_item()
            else
                feedkey("<C-d>", "")
            end
        end,
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                local selected_entry = cmp.core.view:get_selected_entry()
                if selected_entry then
                    cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
                else
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    print("item selected")
                    cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
                end
            else
                -- if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                -- 	vim.fn["UltiSnips#ExpandSnippetOrJump"]()
                if vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                else
                    fallback()
                end
            end
        end,
    },
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
