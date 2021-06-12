require("jacobfoard.prefs")

-- Packer get installed via nix so we don't need to bootstrap
require("packer").startup(function()
    use 'wbthomason/packer.nvim'
  -- Theme stuff
  use "glepnir/galaxyline.nvim"
  -- use {"jacobfoard/vim-code-dark", branch = "personal-changes"}
  use "lewis6991/gitsigns.nvim"
  use "APZelos/blamer.nvim"
  use "folke/todo-comments.nvim"

  -- Navigation Stuff
  use "numToStr/Navigator.nvim"
  use "t9md/vim-choosewin"
  use {"kyazdani42/nvim-tree.lua", requires = {"kyazdani42/nvim-web-devicons"}}

  -- use "sheerun/vim-polyglot"
  use "LnL7/vim-nix"

  -- Highlight colors inline like #ffffff
  use "norcalli/nvim-colorizer.lua"

  -- Telescope Replaces FZF
  use {"nvim-telescope/telescope.nvim", requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}}
  use "nvim-telescope/telescope-project.nvim"
  use "windwp/nvim-spectre"

  -- LSP/Snippet Related Things
  use "neovim/nvim-lspconfig"
  use "folke/lua-dev.nvim"
  use "OmniSharp/omnisharp-vim"
  use "nvim-lua/lsp-status.nvim"
  use "hrsh7th/nvim-compe"
  use "hrsh7th/vim-vsnip"
  use "hrsh7th/vim-vsnip-integ"
  use "onsails/lspkind-nvim"
  use "glepnir/lspsaga.nvim"
  use "RRethy/vim-illuminate"
  use "windwp/nvim-autopairs"
  use "AndrewRadev/splitjoin.vim"
  use "folke/lsp-trouble.nvim"
  use "ray-x/lsp_signature.nvim"

  use "folke/which-key.nvim"


  -- Misc
  -- use {"fatih/vim-go", run = ":GoUpdateBinaries", ft = "go"}
  -- use "crispgm/nvim-go"
  use "tomtom/tcomment_vim"
  use "tpope/vim-eunuch"
  use "tpope/vim-abolish"
  use "beauwilliams/focus.nvim"

  -- Treesitter
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/playground"
  use "p00f/nvim-ts-rainbow"
  use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}

  -- Dadbod
  use "tpope/vim-dadbod"
  use "kristijanhusak/vim-dadbod-completion"
  use "kristijanhusak/vim-dadbod-ui"

  -- use "yamatsum/nvim-web-nonicons"
  use "phaazon/hop.nvim"

  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
end)

require("jacobfoard.autocommands")
require("jacobfoard.go")
require("jacobfoard.keys")
require("jacobfoard.lsp")
require("jacobfoard.misc")
require("jacobfoard.setup")
require("jacobfoard.statusline")
-- require("jacobfoard.telescope")
require("jacobfoard.tmux")
require("jacobfoard.tree")
require("jacobfoard.treesitter")
require("jacobfoard.vim")


