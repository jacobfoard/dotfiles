local g = vim.g
local tree_cb = require("nvim-tree.config").nvim_tree_callback

-- g.nvim_tree_width = 10 --30 by default
-- g.nvim_tree_ignore = { ".git", "bazel-bin", "bazel-out", "bazel-testlogs", ".direnv", ".DS_Store" }
-- g.nvim_tree_auto_open = 0
-- g.nvim_tree_auto_close = 1
-- g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 1
-- g.nvim_tree_tab_open = 1
-- g.nvim_tree_width_allow_resize = 1
-- g.nvim_tree_lsp_diagnostics = 1
-- g.nvim_tree_hijack_cursor = 0

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

-- vim.g.nvim_tree_bindings = {
-- 	{ key = "<CR>", cb = tree_cb("edit") },
-- 	{ key = "o", cb = tree_cb("edit") },
-- 	{ key = "s", cb = tree_cb("vsplit") },
-- 	{ key = "i", cb = tree_cb("split") },
-- 	{ key = "t", cb = tree_cb("tabnew") },
-- 	{ key = "<BS>", cb = tree_cb("close_node") },
-- 	{ key = "<S-CR>", cb = tree_cb("close_node") },
-- 	{ key = "go", cb = tree_cb("preview") },
-- 	{ key = "I", cb = tree_cb("toggle_ignored") },
-- 	{ key = "H", cb = tree_cb("toggle_dotfiles") },
-- 	{ key = "R", cb = tree_cb("refresh") },
-- 	{ key = "a", cb = tree_cb("create") },
-- 	{ key = "d", cb = tree_cb("remove") },
-- 	{ key = "r", cb = tree_cb("rename") },
-- 	{ key = "<C-r>", cb = tree_cb("full_rename") },
-- 	{ key = "x", cb = tree_cb("cut") },
-- 	{ key = "y", cb = tree_cb("copy") },
-- 	{ key = "p", cb = tree_cb("paste") },
-- 	{ key = "[c", cb = tree_cb("prev_git_item") },
-- 	{ key = "]c", cb = tree_cb("next_git_item") },
-- 	{ key = "-", cb = tree_cb("dir_up") },
-- 	{ key = "q", cb = tree_cb("close") },
-- }

require("nvim-tree").setup({
    auto_close = true,
    open_on_tab = true,
    hijack_cursor = true,
    diagnostics = {
        enabled = true,
    },

    filters = {
        dotfiles = false,
        custom = {
            ".git",
            "bazel-bin",
            "bazel-out",
            "bazel-testlogs",
            ".direnv",
            ".DS_Store",
            "bazel-" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
        },
    },

    update_focused_file = {
        enable = true,
    },

    view = {
        -- if true the tree will resize itself after opening a file
        auto_resize = false,
        mappings = {
            -- custom only false will merge the list with the default mappings
            -- if true, it will only use your list to set the mappings
            custom_only = false,
            -- list of mappings to set on the tree manually
            list = {
                { key = "<CR>", cb = tree_cb("edit") },
                { key = "o", cb = tree_cb("edit") },
                { key = "s", cb = tree_cb("vsplit") },
                { key = "i", cb = tree_cb("split") },
                { key = "t", cb = tree_cb("tabnew") },
                { key = "<BS>", cb = tree_cb("close_node") },
                { key = "<S-CR>", cb = tree_cb("close_node") },
                { key = "go", cb = tree_cb("preview") },
                { key = "I", cb = tree_cb("toggle_ignored") },
                { key = "H", cb = tree_cb("toggle_dotfiles") },
                { key = "R", cb = tree_cb("refresh") },
                { key = "a", cb = tree_cb("create") },
                { key = "d", cb = tree_cb("remove") },
                { key = "r", cb = tree_cb("rename") },
                { key = "<C-r>", cb = tree_cb("full_rename") },
                { key = "x", cb = tree_cb("cut") },
                { key = "y", cb = tree_cb("copy") },
                { key = "p", cb = tree_cb("paste") },
                { key = "[c", cb = tree_cb("prev_git_item") },
                { key = "]c", cb = tree_cb("next_git_item") },
                { key = "-", cb = tree_cb("dir_up") },
                { key = "q", cb = tree_cb("close") },
                { key = "?", cb = tree_cb("toggle_help") },
            },
        },
    },
})
