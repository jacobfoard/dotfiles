local lsp = require("lspconfig")
local lsp_status = require("lsp-status")
local sig = require("lsp_signature")
local illuminate = require("illuminate")

local on_attach_vim = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  lsp_status.on_attach(client)
  illuminate.on_attach(client)
  sig.on_attach({bind = false, use_lspsaga = true})

  -- Mappings.
  local opts = {noremap = true, silent = true}

  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K",
                              "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>",
                              opts)
end

lsp_status.register_progress()

local default_lsp_config = {on_attach = on_attach_vim, capabilities = lsp_status.capabilities}

local sumneko_cmd
if vim.fn.executable("lua-language-server") == 1 then
  sumneko_cmd = {"lua-language-server"}
else
  local sumneko_root_path = vim.fn.stdpath("cache") .. "/lspconfig/sumneko_lua/lua-language-server"
  sumneko_cmd = {
    sumneko_root_path .. "/bin/macOS/lua-language-server",
    "-E",
    sumneko_root_path .. "/main.lua",
  }
end

local luaVersion = "LuaJIT"
local cwd = vim.fn.getcwd()
local hasWezterm = cwd:find("wezterm")

if hasWezterm ~= nil then luaVersion = "Lua 5.3" end

local luadev = require("lua-dev").setup({
  lspconfig = {cmd = sumneko_cmd, settings = {Lua = {runtime = luaVersion}}},
})
--
local servers = {
  bashls = {},
  yamlls = {},
  rnix = {},
  rust_analyzer = {},
  sourcekit = {},

  tsserver = {
    init_options = {preferences = {importModuleSpecifierPreference = "non-relative"}},
  },

  jsonls = {
    cmd = {"vscode-json-languageserver", "--stdio"},
    commands = {
      Format = {function() vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0}) end},
    },
  },

  gopls = {
    settings = {
      gopls = {
        usePlaceholders = true,
        analyses = {nilness = true, unusedparams = true, unusedwrite = true},
        verboseOutput = true,
        codelenses = {
          gc_details = true,
          tidy = true,
          upgrade_dependency = true,
          regenerate_cgo = true,
        },
        experimentalPostfixCompletions = true,
        gofumpt = true,
        ["local"] = "github.com/greenpark",
        semanticTokens = true,
        experimentalWorkspaceModule = true,
        linksInHover = false,
      },
    },
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
            resolveSupport = {properties = {"documentation", "detail", "additionalTextEdits"}},
          },
        },
      },
    },
  },

  diagnosticls = {
    filetypes = {"go", "typescript"},
    init_options = {
      filetypes = {go = "golangci-lint", typescript = "eslint"},
      linters = {
        ["golangci-lint"] = {
          command = "golangci-lint",
          rootPatterns = {".git", "go.mod"},
          debounce = 2000,
          args = {"run", "--out-format", "json", "--timeout", "7m", "--sort-results"},
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
          rootPatterns = {".git"},
          debounce = 100,
          args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
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
          securities = {["2"] = "error", ["1"] = "warning"},
        },
      },
    },
  },

  -- sumneko_lua =  require("lua_lsp"),
  sumneko_lua = luadev,
  -- sumneko_lua = {
  --   cmd = sumneko_cmd;
  --   settings = {
  --     Lua = {
  --       runtime = {
  --         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
  --         version = luaVersion,
  --         -- Setup your lua path
  --         path = vim.split(package.path, ";"),
  --       },
  --       diagnostics = {
  --         -- Get the language server to recognize the `vim` global
  --         globals = {"vim", "use"},
  --       },
  --       workspace = {
  --         -- Make the server aware of Neovim runtime files
  --         library = {
  --           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
  --           [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
  --         },
  --       },
  --     },
  --   },
  -- },

  omnisharp = {
    cmd = {
      "mono",
      "/Users/jacobfoard/Downloads/omnisharp-mono/OmniSharp.exe",
      "-lsp",
      "--hostPID",
      tostring(vim.fn.getpid()),
    },
  },
}

for server, config in pairs(servers) do
  lsp[server].setup(vim.tbl_deep_extend("force", default_lsp_config, config))
end

vim.api.nvim_command [[autocmd CursorHold *.go lua require('lspsaga.hover').render_hover_doc()]]
-- vim.api.nvim_command [[autocmd CursorHold *.tf lua require('lspsaga.hover').render_hover_doc()]]
-- vim.api.nvim_command [[autocmd CursorHold *.yaml lua vim.lsp.buf.hover()]]

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {spacing = 4},
    signs = true,
    update_in_insert = false,
  })

require("compe").setup {
  preselect = "always",
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = false,
    tags = true,
    vsnip = true,
    vim_dadbod_completion = true,
  },
}

