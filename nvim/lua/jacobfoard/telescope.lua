-- Telescope.nvim configuration
local ts = require("telescope")
local actions = require("telescope.actions")

ts.setup({
  defaults = {
    mappings = {
      i = {
        -- ["<esc>"] = actions.close,
      },
    },
  },
})
