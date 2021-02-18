local g = vim.g

-- g.nvim_tree_width = 40 "30 by default
g.nvim_tree_ignore = {".git"}
g.nvim_tree_auto_open = 0
g.nvim_tree_auto_close = 1
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_tab_open = 1
g.nvim_tree_width_allow_resize = 1

-- You can edit keybindings be defining this variable
-- You don't have to define all keys.
-- NOTE: the 'edit' key will wrap/unwrap a folder and open a file
g.nvim_tree_bindings = {
  edit = {"<CR>", "o"},
  edit_vsplit = "s",
  edit_split = "i",
  edit_tab = "t",
  close_node = {"<S-CR>", "<BS>"},
  toggle_ignored = "I",
  toggle_dotfiles = "H",
  refresh = "R",
  preview = "go",
  cd = "cd",
  create = "a",
  remove = "d",
  rename = "r",
  cut = "x",
  copy = "y",
  paste = "p",
  prev_git_item = "[c",
  next_git_item = "]c",
}
