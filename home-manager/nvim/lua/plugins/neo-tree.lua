---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    local events = require "neo-tree.events"
    opts.event_handlers = opts.event_handlers or {}
  end,
  init = function()
    -- Auto-open neo-tree when nvim is started without a file argument
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then vim.cmd "Neotree show" end
      end,
    })
  end,
}
