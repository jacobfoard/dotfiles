{ config, pkgs, ... }:

{
  config = {
    programs.nixvim = {
      enable = true;
      clipboard.register = "unnamedplus";
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "frappe";
      };
      opts = {
        autoread = true;
        autowrite = true;
        backspace = "indent,eol,start";
        backup = false;
        cmdheight = 0;
        completeopt = "menuone,noselect";
        expandtab = true;
        hidden = true;
        ignorecase = true;
        inccommand = "nosplit";
        laststatus = 3;
        mouse = "nvia"; # default is nvi
        number = true;
        shiftwidth = 2;
        shortmess = "filnxtToOFc"; # default is filnxtToOF
        showmode = false;
        splitbelow = true;
        splitright = true;
        swapfile = false;
        syntax = "on";
        tabstop = 2;
        termguicolors = true;
        # undodir = "~/.config/nvim/vim-persisted-undo";
        # undofile = true;
        updatetime = 500;
        wrap = false;
      };
      keymaps = [
        # -- Highlights code for multiple indents without reselecting
        { mode = "v"; key = "<"; action = "<gv"; }
        { mode = "v"; key = ">"; action = ">gv"; }
        { mode = "n"; key = "<"; action = "<<"; }
        { mode = "n"; key = ">"; action = ">>"; }

        { mode = ""; key = "<C-g>"; action = "require('telescope.builtin').live_grep()"; options.silent = true; }
        # -- <Ctrl-l> redraws the screen and removes any search highlighting.
        { mode = "n"; key = "<C-l>"; action = "<cmd> noh<CR><C-l>"; }

        { mode = "n"; key = "-"; action = "<cmd> ChooseWinSwap<cr>"; }

        #-- Shift move lines
        { mode = "n"; key = "<S-Up>"; action = "<cmd> m .-2<CR>=="; }
        { mode = "n"; key = "<S-Down>"; action = "<cmd> m .+1<CR>=="; }
        { mode = "i"; key = "<S-Up>"; action = "<Esc>:m .-2<CR>==gi"; }
        { mode = "i"; key = "<S-Down>"; action = "<Esc>:m .+1<CR>==gi"; }
        { mode = "v"; key = "<S-Down>"; action = ":m '>+1<CR>gv=gv"; }
        { mode = "v"; key = "<S-Up>"; action = ":m '<-2<CR>gv=gv"; }

        #-- Resize buffers
        { mode = "n"; key = "<M-up>"; action = "<cmd>resize -5<cr>"; }
        { mode = "n"; key = "<M-down>"; action = "<cmd>resize +5<cr>"; }
        { mode = "n"; key = "<M-left>"; action = "<cmd>vertical resize -5<cr>"; }
        { mode = "n"; key = "<M-right>"; action = "<cmd>vertical resize +5<cr>"; }
        #-- esc works like normal in a term
        { mode = "t"; key = "<ESC>"; action = "<C-\\><C-N>"; }
        #-- autocmd TermOpen * setlocal nonu

        #-- center on page down
        { mode = "n"; key = "<PageDown>"; action = "<PageDown>zz"; }
        { mode = "i"; key = "<PageDown>"; action = "<ESC><PageDown>zzi"; }

        { mode = ""; key = "<C-f>"; action = "require('telescope.builtin').find_files()"; options.silent = true; }
        { mode = ""; key = "<leader>r"; action = "require('telescope.builtin').resume()"; options.silent = true; }
        { mode = "n"; key = "nt"; action = "<cmd>NvimTreeToggle<cr>"; }

        { mode = "n"; key = "<leader>w"; action = "<cmd>lua require'hop'.hint_words()<cr>"; }
        { mode = "n"; key = "<leader>w"; action = "<cmd>lua require'hop'.hint_words()<cr>"; }
        { mode = "n"; key = "<leader>t"; action = "<cmd>TroubleToggle<cr>"; }

        #-- Map <C-s> to <C-a> for incrementing
        #-- since <C-a> is used by tmux
        { mode = "n"; key = "<C-s>"; action = "<C-a>"; }

        { mode = [ "n" "t" ]; key = "<A-h>"; action = "<CMD>NavigatorLeft<CR>"; }
        { mode = [ "n" "t" ]; key = "<A-l>"; action = "<CMD>NavigatorRight<CR>"; }
        { mode = [ "n" "t" ]; key = "<A-k>"; action = "<CMD>NavigatorUp<CR>"; }
        { mode = [ "n" "t" ]; key = "<A-j>"; action = "<CMD>NavigatorDown<CR>"; }
        { mode = [ "n" "t" ]; key = "<A-p>"; action = "<CMD>NavigatorPrevious<CR>"; }
      ];
      plugins = {
        dap = {
          enable = true;
          extensions.dap-go.enable = true;
          extensions.dap-virtual-text.enable = true;
          extensions.dap-ui.enable = true;
        };
        fidget.enable = true;
        gitsigns = {
          enable = true;
          # signs = {
          #   add = { hl = "GitGutterAdd"; text = "+"; };
          #   change = { hl = "GitGutterChange"; text = "~"; };
          #   delete = { hl = "GitGutterDelete"; text = "_"; };
          #   topdelete = { hl = "GitGutterDelete"; text = "‾"; };
          #   changedelete = { hl = "GitGutterChange"; text = "~"; };
          # };
        };
        illuminate.enable = true;
        # indent-blankline = {
        #   enable = true;
        #   indent.tabChar = "▎";
        # };
        lsp = {
          enable = true;
          servers = {
            gopls.enable = true;
            lua-ls.enable = true;
            rnix-lsp.enable = true;
          };
        };
        lspkind.enable = true;
        lspsaga.enable = true;
        nix.enable = true;
        nvim-autopairs.enable = true;
        nvim-colorizer.enable = true;
        cmp = {
          enable = true;
          # sources = [
          #   { name = "buffer"; }
          #   { name = "path"; }
          #   { name = "nvim"; }
          #   { name = "cmdline"; }
          #   { name = "git"; }
          #   { name = "dap"; }
          # ];
          settings.mapping = { }; # TODO: fill it out
        };
        # copilot-cmp.enable = true;
        # copilot-lua.enable = true;
        nvim-tree = {
          enable = true;
          disableNetrw = true;
          hijackCursor = true;
          diagnostics = {
            enable = true;
            showOnDirs = true;
          };
          tab = {
            sync = {
              open = true;
            };
          };
          updateFocusedFile.enable = true;
          view.preserveWindowProportions = true;
        };
        # oil.enable = true; # Look into this one
        telescope.enable = true; #TODO Telescope github
        todo-comments.enable = true;
        treesitter = {
          enable = true;
          # folding = true;
          # indent = true;
          settings = {
            indent = {
              enable = true;
            };
          };
          nixvimInjections = true;
        };
        # treesitter-context.enable = true;
        trouble.enable = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        blamer-nvim
        Navigator-nvim
        vim-choosewin
        nvim-spectre
        octo-nvim
        splitjoin-vim
        tcomment_vim
        vim-eunuch
        vim-abolish
        nvim-web-devicons

        # From Overlay
        windline
        focus

        indent-blankline-nvim # this one is supported, but need some extra configs
        rainbow-delimiters-nvim # Same
        #         use("nvim-lua/lsp-status.nvim") ?
        # need to add in https://github.com/nvim-focus/focus.nvim
      ];
      extraConfigLuaPost = ''
        require("Navigator").setup({ auto_save = "current", disable_on_zoom = true })
        require("focus").setup({ cursorline = false, signcolumn = false })
        require("spectre").setup()
        require("octo").setup()
        require("statusline")

        vim.opt.list = true
        vim.opt.listchars:append("space:⋅")
        vim.opt.listchars:append("eol:↴")

        local g = vim.g
        g.blamer_enabled = 1
        g.blamer_delay = 500
        g.blamer_template = "<author>, <committer-time> • <summary>"
        g.choosewin_overlay_enable = 0
        g.gitgutter_highlight_linenrs = 1

        vim.o.foldcolumn = '1' -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local highlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan",
        }

        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        vim.g.rainbow_delimiters = { highlight = highlight }
        require("ibl").setup { 
          indent = { tab_char = "▎" },
          scope = { 
            highlight = highlight,
            include = {
              node_type = {
                ["*"] = {
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
                  "var_declaration",
                  "type_declaration",
                  "const_declaration"
                }
              }
            }
          } 
        }

        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

        local ignore_filetypes = { 'NvimTree' }
        local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

        local augroup =
            vim.api.nvim_create_augroup('FocusDisable', { clear = true })

        vim.api.nvim_create_autocmd('WinEnter', {
            group = augroup,
            callback = function(_)
                if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
                then
                    vim.w.focus_disable = true
                else
                    vim.w.focus_disable = false
                end
            end,
            desc = 'Disable focus autoresize for BufType',
        })

        vim.api.nvim_create_autocmd('FileType', {
            group = augroup,
            callback = function(_)
                if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                    vim.b.focus_disable = true
                else
                    vim.b.focus_disable = false
                end
            end,
            desc = 'Disable focus autoresize for FileType',
        })
      '';
      extraConfigVim = ''
        autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
      '';
    };
  };
}
