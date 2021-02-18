local lsp = require("lspconfig")
local lsp_status = require("lsp-status")

local on_attach_vim = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  lsp_status.on_attach(client)

  -- Mappings.
  local opts = {noremap = true, silent = true}
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api
    .nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>",
                              opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)
end

lsp_status.register_progress()

local default_lsp_config = {on_attach = on_attach_vim, capabilities = lsp_status.capabilities}

local sumneko_root_path = vim.fn.stdpath("cache") .. "/lspconfig/sumneko_lua/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"
--
-- :LspInstall needed
local servers = {
  bashls = {},
  vimls = {},
  yamlls = {},
  jsonls = {},

  gopls = {
    settings = {
      gopls = {
        usePlaceholders = true,
        analyses = {unusedparams = true},
        codelenses = {gc_details = true},
        experimentalWorkspaceModule = true,
        env = {GOFLAGS = "-tags=dev"},
        linksInHover = false,
      },
    },
    capabilities = {textDocument = {completion = {completionItem = {snippetSupport = true}}}},

  },

  terraformls = {
    cmd = {"terraform-ls", "serve"},
    filetypes = {"terraform"},
    init_options = {
      rootModulePaths = {
        "~/go/src/github.com/greenpark/infra/cloudflare",
        "~/go/src/github.com/greenpark/infra/datadog",
        "~/go/src/github.com/greenpark/infra/github",
        "~/go/src/github.com/greenpark/infra/greenpark-analytics",
        "~/go/src/github.com/greenpark/infra/greenpark-api",
        "~/go/src/github.com/greenpark/infra/greenpark-dev",
        "~/go/src/github.com/greenpark/infra/greenpark-infra",
        "~/go/src/github.com/greenpark/infra/greenpark-prod",
        "~/go/src/github.com/greenpark/infra/greenpark-staging",
        "~/go/src/github.com/greenpark/infra/pagerduty",
        "~/go/src/github.com/greenpark/infra/terraform-cloud",
      },
    },
    capabilities = {textDocument = {completion = {completionItem = {snippetSupport = true}}}},
  },

  diagnosticls = {
    filetypes = {"go"},
    init_options = {
      filetypes = {go = "golangci-lint"},
      linters = {
        ["golangci-lint"] = {
          command = "golangci-lint",
          rootPatterns = {".git", "go.mod"},
          debounce = 2000,
          args = {"run", "--out-format", "json", "--timeout", "7m", "--build-tags", "dev"},
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
      },
    },
  },

  sumneko_lua = {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {"vim", "use"},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
      },
    },
  },

  omnisharp = {
    cmd = {
      "/usr/local/bin/mono",
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
vim.api.nvim_command [[autocmd CursorHold *.tf lua require('lspsaga.hover').render_hover_doc()]]
-- vim.api.nvim_command [[autocmd CursorHold *.yaml lua vim.lsp.buf.hover()]]

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {spacing = 4},
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,
    update_in_insert = false,
  })


require"compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "always",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  allow_prefix_unmatch = false,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = true,
    ultisnips = true,
  },
}

