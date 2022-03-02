local map = vim.api.nvim_set_keymap

local mapper = function(mode, key, result, isLua)
    if isLua then
        result = "<cmd>lua " .. result .. "<CR>"
    end
    map(mode, key, result, { noremap = true, silent = true })
end

-- Highlights code for multiple indents without reselecting
mapper("v", "<", "<gv")
mapper("v", ">", ">gv")
mapper("n", "<", "<<")
mapper("n", ">", ">>")

mapper("", "<C-g>", "require('telescope.builtin').live_grep()", true)
-- <Ctrl-l> redraws the screen and removes any search highlighting.
mapper("n", "<C-l>", "<cmd> noh<CR><C-l>")

mapper("n", "-", "<cmd> ChooseWinSwap<cr>")

-- Shift move lines
mapper("n", "<S-Up>", "<cmd> m .-2<CR>==")
mapper("n", "<S-Down>", "<cmd> m .+1<CR>==")
mapper("i", "<S-Up>", "<Esc>:m .-2<CR>==gi")
mapper("i", "<S-Down>", "<Esc>:m .+1<CR>==gi")
mapper("v", "<S-Down>", ":m '>+1<CR>gv=gv")
mapper("v", "<S-Up>", ":m '<-2<CR>gv=gv")

-- Resize buffers
mapper("n", "<M-up>", "<cmd>resize -5<cr>")
mapper("n", "<M-down>", "<cmd>resize +5<cr>")
mapper("n", "<M-left>", "<cmd>vertical resize -5<cr>")
mapper("n", "<M-right>", "<cmd>vertical resize +5<cr>")
-- esc works like normal in a term
mapper("t", "<ESC>", "<C-\\><C-N>")
-- autocmd TermOpen * setlocal nonu

-- center on page down
mapper("n", "<PageDown>", "<PageDown>zz")
mapper("i", "<PageDown>", "<ESC><PageDown>zzi")

mapper("", "<C-f>", "require('telescope.builtin').find_files()", true)
mapper("n", "nt", "<cmd>NvimTreeToggle<cr>")

mapper("n", "<leader>w", "<cmd>lua require'hop'.hint_words()<cr>")
mapper("n", "<leader>w", "<cmd>lua require'hop'.hint_words()<cr>")
mapper("n", "<leader>t", "<cmd>TroubleToggle<cr>")

-- Map <C-s> to <C-a> for incrementing
-- since <C-a> is used by tmux
mapper("n", "<C-s>", "<C-a>")
