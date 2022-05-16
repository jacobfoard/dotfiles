local lsp = require("lspconfig")
-- local lsp_status = require("lsp-status")
-- local sig = require("lsp_signature")
local illuminate = require("illuminate")

local on_attach_vim = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- lsp_status.on_attach(client)
    illuminate.on_attach(client)
    -- sig.on_attach({ bind = false, use_lspsaga = true })

    -- Mappings.
    local opts = { noremap = true, silent = true }

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)
end

-- lsp_status.register_progress()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
-- local capabilities = require("cmp_nvim_lsp").update_capabilities(lsp_status.capabilities)
local default_lsp_config = { on_attach = on_attach_vim, capabilities = capabilities }

local luaVersion = "LuaJIT"
local cwd = vim.fn.getcwd()
local hasWezterm = cwd:find("wezterm")

local goplsLocal = "github.com/greenpark"
local isMango = cwd:find("mango")

if isMango ~= nil then
    goplsLocal = "mango.gp"
end

if hasWezterm ~= nil then
    luaVersion = "Lua 5.3"
end

-- require("rust-tools").setup({
--     server = default_lsp_config,
-- })

local luadev = require("lua-dev").setup({
    library = {
        vimruntime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true, -- installed opt or start plugins in packpath
    },
    runtime_path = true,
    lspconfig = {
        settings = {
            Lua = {
                runtime = luaVersion,
                format = {
                    enable = false,
                },
                diagnostics = {
                    globals = { "use" },
                },
                workspace = {
                    checkThirdParty = false,
                },
            },
        },
    },
})

local servers = {
    bashls = {},
    yamlls = {},
    rnix = {},
    sourcekit = {}, -- Swift/ObjC
    vimls = {},
    -- zls = {}, -- Zig

    tsserver = { init_options = { preferences = { importModuleSpecifierPreference = "non-relative" } } },

    jsonls = {
        cmd = { "vscode-json-languageserver", "--stdio" },
        -- Trying to fix json not being seen as jsonc
        -- Taken from https://github.com/neovim/nvim-lspconfig/pull/1195/files#diff-154bccef18fe5b30f292584c9e30b32cc41068172752fc4a9c5a8ab69673c8b9R42-R46
        get_language_id = function(_, filetype)
            if filetype == "json" then
                return "jsonc" -- If you want to allow comments in json, You can specify `jsonc` language id.
            end
            return filetype
        end,
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                end,
            },
        },
    },

    gopls = {
        -- cmd = { "gopls" },
        settings = {
            gopls = {
                usePlaceholders = true,
                analyses = { nilness = true, unusedparams = true, unusedwrite = true },
                verboseOutput = true,
                codelenses = {
                    gc_details = false,
                    tidy = false,
                    upgrade_dependency = false,
                    regenerate_cgo = false,
                },
                experimentalPostfixCompletions = true,
                gofumpt = true,
                ["local"] = goplsLocal,
                semanticTokens = true,
                experimentalWorkspaceModule = false,
                linksInHover = false,
                annotations = {
                    bounds = true,
                    escape = true,
                    inline = true,
                    ["nil"] = true,
                },
            },
        },
    },

    diagnosticls = {
        filetypes = { "go", "typescript", "lua" },
        init_options = {
            filetypes = { go = "golangci-lint", typescript = "eslint", nix = "statix" },
            formatFiletypes = { typescript = "prettier", lua = "lua_format" },
            formatters = {
                ["lua_format"] = {
                    command = "stylua",
                    args = { "%filepath" },
                    rootPatterns = { ".stylua.toml" },
                },
                prettier = {
                    command = "./node_modules/.bin/prettier",
                    args = { "--stdin", "--stdin-filepath", "%filepath" },
                    rootPatterns = {
                        "package.json",
                        ".prettierrc",
                        ".prettierrc.json",
                        ".prettierrc.toml",
                        ".prettierrc.json",
                        ".prettierrc.yml",
                        ".prettierrc.yaml",
                        ".prettierrc.json5",
                        ".prettierrc.js",
                        ".prettierrc.cjs",
                        "prettier.config.js",
                        "prettier.config.cjs",
                    },
                },
            },
            linters = {
                ["golangci-lint"] = {
                    command = "golangci-lint",
                    rootPatterns = { ".git", "go.mod" },
                    debounce = 2000,
                    args = { "run", "--out-format", "json", "--timeout", "7m", "--sort-results" },
                    sourceName = "golangci-lint",
                    parseJson = {
                        sourceName = "Pos.Filename",
                        sourceNameFilter = true,
                        errorsRoot = "Issues",
                        line = "Pos.Line",
                        column = "Pos.Column",
                        message = "${Text} [${FromLinter}]",
                    },
                },
                eslint = {
                    command = "./node_modules/.bin/eslint",
                    rootPatterns = { ".git" },
                    debounce = 100,
                    args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
                    sourceName = "eslint",
                    parseJson = {
                        errorsRoot = "[0].messages",
                        line = "line",
                        column = "column",
                        endLine = "endLine",
                        endColumn = "endColumn",
                        message = "${message} [${ruleId}]",
                        security = "severity",
                    },
                    securities = { ["2"] = "error", ["1"] = "warning" },
                },
                -- statix = {
                -- 	command = "statix",
                -- 	rootPatterns = { ".git" },
                -- 	debounce = 100,
                -- 	args = { "check", "--stdin", "--format", "json" },
                -- 	sourceName = "statix",
                -- 	parseJson = {
                -- 		errorsRoot = "report",
                -- 	},
                -- },
            },
        },
    },

    sumneko_lua = luadev,

    -- omnisharp = {
    -- 	cmd = {
    -- 		"mono",
    -- 		"/Users/jacobfoard/Downloads/omnisharp-mono/OmniSharp.exe",
    -- 		"-lsp",
    -- 		"--hostPID",
    -- 		tostring(vim.fn.getpid()),
    -- 	},
    -- },
}

for server, config in pairs(servers) do
    lsp[server].setup(vim.tbl_deep_extend("force", default_lsp_config, config))
end

vim.cmd([[autocmd BufWritePre *.go lua vim.lsp.buf.formatting_seq_sync()]])
vim.cmd([[autocmd BufWritePost *.lua lua vim.lsp.buf.formatting_seq_sync() vim.api.nvim_command("edit")]]) -- LuaFormat is weird so use a Post
vim.cmd([[autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_seq_sync()]])
vim.cmd([[autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_seq_sync()]])

-- vim.cmd [[autocmd CursorHold *.go lua require('lspsaga.hover').render_hover_doc()]]
-- vim.api.nvim_command [[autocmd CursorHold *.tf lua require('lspsaga.hover').render_hover_doc()]]
-- vim.api.nvim_command [[autocmd CursorHold *.yaml lua vim.lsp.buf.hover()]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = { spacing = 4 },
    signs = true,
    update_in_insert = false,
})
