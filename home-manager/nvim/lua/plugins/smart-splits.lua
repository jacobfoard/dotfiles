-- Seamless navigation between nvim and wezterm panes
---@type LazySpec
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false, -- Must load early to set IS_NVIM user var for wezterm
  opts = {
    ignored_filetypes = { "NvimTree", "neo-tree" },
    multiplexer_integration = "wezterm",
    at_edge = "stop", -- Let wezterm handle cross-pane navigation
  },
  keys = {
    -- Navigation with Ctrl+Arrow (matches wezterm)
    { "<C-Left>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split/pane" },
    { "<C-Down>", function() require("smart-splits").move_cursor_down() end, desc = "Move to split/pane below" },
    { "<C-Up>", function() require("smart-splits").move_cursor_up() end, desc = "Move to split/pane above" },
    { "<C-Right>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split/pane" },
    -- Resize with Leader+Arrow
    { "<Leader><Left>", function() require("smart-splits").resize_left() end, desc = "Resize left" },
    { "<Leader><Down>", function() require("smart-splits").resize_down() end, desc = "Resize down" },
    { "<Leader><Up>", function() require("smart-splits").resize_up() end, desc = "Resize up" },
    { "<Leader><Right>", function() require("smart-splits").resize_right() end, desc = "Resize right" },
  },
}
