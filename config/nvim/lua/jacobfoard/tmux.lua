local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

map("n", "<C-Left>", "<CMD>lua require('Navigator').left()<cr>", opts)
map("n", "<C-Down>", "<CMD>lua require('Navigator').down()<cr>", opts)
map("n", "<C-Up>", "<CMD>lua require('Navigator').up()<cr>", opts)
map("n", "<C-Right>", "<CMD>lua require('Navigator').right()<cr>", opts)

map("i", "<C-Left>", "<esc><CMD>lua require('Navigator').left()<cr>", opts)
map("i", "<C-Down>", "<esc><CMD>lua require('Navigator').down()<cr>", opts)
map("i", "<C-Up>", "<esc><CMD>lua require('Navigator').up()<cr>", opts)
map("i", "<C-Right>", "<esc><CMD>lua require('Navigator').right()<cr>", opts)

map("t", "<C-Left>", "<C-\\><C-n><CMD>lua require('Navigator').left()<cr>", opts)
map("t", "<C-Down>", "<C-\\><C-n><CMD>lua require('Navigator').down()<cr>", opts)
map("t", "<C-Up>", "<C-\\><C-n><CMD>lua require('Navigator').up()<cr>", opts)
map("t", "<C-Right>", "<C-\\><C-n><CMD>lua require('Navigator').right()<cr>", opts)
--
-- map("i", "<C-w><C-h>", "<esc><C-w><C-h>", opts)
-- map("i", "<C-w><C-j>", "<esc><C-w><C-j>", opts)
-- map("i", "<C-w><C-k>", "<esc><C-w><C-k>", opts)
-- map("i", "<C-w><C-l>", "<esc><C-w><C-l>", opts)
--
-- map("t", "<C-w><C-h>", "<C-\\><C-n><C-w><C-h>", opts)
-- map("t", "<C-w><C-j>", "<C-\\><C-n><C-w><C-j>", opts)
-- map("t", "<C-w><C-k>", "<C-\\><C-n><C-w><C-k>", opts)
-- map("t", "<C-w><C-l>", "<C-\\><C-n><C-w><C-l>", opts)

-- map("n", "<C-Left>", "<CMD>lua require('wezterm').left()<cr>", opts)
-- map("n", "<C-Down>", "<CMD>lua require('wezterm').down()<cr>", opts)
-- map("n", "<C-Up>", "<CMD>lua require('wezterm').up()<cr>", opts)
-- map("n", "<C-Right>", "<CMD>lua require('wezterm').right()<cr>", opts)
--
-- map("n", "<C-w><C-h>", "<CMD>lua require('wezterm').left()<cr>", opts)
-- map("n", "<C-w><C-j>", "<CMD>lua require('wezterm').down()<cr>", opts)
-- map("n", "<C-w><C-k>", "<CMD>lua require('wezterm').up()<cr>", opts)
-- map("n", "<C-w><C-l>", "<CMD>lua require('wezterm').right()<cr>", opts)

-- map("i", "<C-Left>", "<esc><CMD>lua require('wezterm').left()<cr>", opts)
-- map("i", "<C-Down>", "<esc><CMD>lua require('wezterm').down()<cr>", opts)
-- map("i", "<C-Up>", "<esc><CMD>lua require('wezterm').up()<cr>", opts)
-- map("i", "<C-Right>", "<esc><CMD>lua require('wezterm').right()<cr>", opts)
--
-- map("t", "<C-Left>", "<C-\\><C-n><CMD>lua require('wezterm').left()<cr>", opts)
-- map("t", "<C-Down>", "<C-\\><C-n><CMD>lua require('wezterm').down()<cr>", opts)
-- map("t", "<C-Up>", "<C-\\><C-n><CMD>lua require('wezterm').up()<cr>", opts)
-- map("t", "<C-Right>", "<C-\\><C-n><CMD>lua require('wezterm').right()<cr>", opts)
