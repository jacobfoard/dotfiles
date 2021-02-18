local g = vim.g
local map = vim.api.nvim_set_keymap

g.tmux_navigator_no_mappings = 1
g.tmux_navigator_disable_when_zoomed = 1

map("n", "<C-Left>", ":TmuxNavigateLeft<cr>", {noremap = true, silent = true})
map("n", "<C-Down>", ":TmuxNavigateDown<cr>", {noremap = true, silent = true})
map("n", "<C-Up>", ":TmuxNavigateUp<cr>", {noremap = true, silent = true})
map("n", "<C-Right>", ":TmuxNavigateRight<cr>", {noremap = true, silent = true})

map("i", "<C-Left>", "<esc>:TmuxNavigateLeft<cr>", {noremap = true, silent = true})
map("i", "<C-Down>", "<esc>:TmuxNavigateDown<cr>", {noremap = true, silent = true})
map("i", "<C-Up>", "<esc>:TmuxNavigateUp<cr>", {noremap = true, silent = true})
map("i", "<C-Right>", "<esc>:TmuxNavigateRight<cr>", {noremap = true, silent = true})

map("t", "<C-Left>", "<C-\\><C-n>:TmuxNavigateLeft<cr>", {noremap = true, silent = true})
map("t", "<C-Down>", "<C-\\><C-n>:TmuxNavigateDown<cr>", {noremap = true, silent = true})
map("t", "<C-Up>", "<C-\\><C-n>:TmuxNavigateUp<cr>", {noremap = true, silent = true})
map("t", "<C-Right>", "<C-\\><C-n>:TmuxNavigateRight<cr>", {noremap = true, silent = true})
