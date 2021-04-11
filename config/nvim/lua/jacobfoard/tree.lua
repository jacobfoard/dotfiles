local g = vim.g
local tree_cb = require("nvim-tree.config").nvim_tree_callback

-- g.nvim_tree_width = 10 --30 by default
g.nvim_tree_ignore = {".git", "bazel-bin", "bazel-out", "bazel-testlogs", ".direnv", ".DS_Store"}
g.nvim_tree_auto_open = 0
g.nvim_tree_auto_close = 1
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_tab_open = 1
g.nvim_tree_width_allow_resize = 1
g.nvim_tree_lsp_diagnostics = 1
g.nvim_tree_hijack_cursor = 0

-- g.nvim_tree_icons = {
--  ["default"] = "",
--  ["symlink"] = "",
--  ["git"] = {
--    ["unstaged"] = "✗",
--    ["staged"] = "✓",
--    ["unmerged"] = "",
--    ["renamed"] = "➜",
--    ["untracked"] = "",
--    ["deleted"] = "",
--    ["ignored"] = "◌"
--    },
--  ["folder"] = {
--    ["default"] = "",
--    ["open"] = "",
--    ["empty"] = "",
--    ["empty_open"] = "",
--    ["symlink"] = "",
--    ["symlink_open"] = "",
--    },
--    ["lsp"] = {
--      ["hint"] = "",
--      ["info"] = "",
--      ["warning"] = "",
--      ["error"] = "",
--    }
--  }

vim.g.nvim_tree_bindings = {
  ["<CR>"] = tree_cb("edit"),
  ["o"] = tree_cb("edit"),
  ["s"] = tree_cb("vsplit"),
  ["i"] = tree_cb("split"),
  ["t"] = tree_cb("tabnew"),
  ["<BS>"] = tree_cb("close_node"),
  ["<S-CR>"] = tree_cb("close_node"),
  ["go"] = tree_cb("preview"),
  ["I"] = tree_cb("toggle_ignored"),
  ["H"] = tree_cb("toggle_dotfiles"),
  ["R"] = tree_cb("refresh"),
  ["a"] = tree_cb("create"),
  ["d"] = tree_cb("remove"),
  ["r"] = tree_cb("rename"),
  ["<C-r>"] = tree_cb("full_rename"),
  ["x"] = tree_cb("cut"),
  ["y"] = tree_cb("copy"),
  ["p"] = tree_cb("paste"),
  ["[c"] = tree_cb("prev_git_item"),
  ["]c"] = tree_cb("next_git_item"),
  ["-"] = tree_cb("dir_up"),
  ["q"] = tree_cb("close"),
}
