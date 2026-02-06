-- Customize Treesitter for Nix-managed parsers
-- Parsers are added to runtimepath via lua/jacob/init.lua

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    auto_install = false, -- Nix handles parser installation
    ensure_installed = {}, -- Don't install any parsers via treesitter
    highlight = { enable = true },
    indent = { enable = true },
  },
}
