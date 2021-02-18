-- General Vim Options
require("jacobfoard.prefs")

-- Bootstrap/load packer.nvim
require("jacobfoard.packer")

require("packer").startup(function()
  -- Packer can manage itself as an optional usein
  use {"wbthomason/packer.nvim", opt = true}

  -- Theme Stuff
  use "glepnir/galaxyline.nvim"
  use {"jacobfoard/vim-code-dark", branch = "personal-changes"}
  use "lewis6991/gitsigns.nvim"

  -- Filetypes for when Treesitter isn't avaliable
  use "sheerun/vim-polyglot"
  use "keith/swift.vim"
  use "hashivim/vim-terraform"


  -- Navigation Stuff
  use "christoomey/vim-tmux-navigator"
  use "t9md/vim-choosewin"
  use "tmux-plugins/vim-tmux-focus-events"
  use {"kyazdani42/nvim-tree.lua", requires = {"kyazdani42/nvim-web-devicons"}}

  use "APZelos/blamer.nvim"

  -- Highlight colors inline like #ffffff
  use "norcalli/nvim-colorizer.lua"

  -- Telescope Replaces FZF
  use {"nvim-telescope/telescope.nvim", requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}}
  use "nvim-telescope/telescope-project.nvim"


  -- LSP/Snippet Related Things
  use "neovim/nvim-lspconfig"
  use "alexaandru/nvim-lspupdate"
  use "tjdevries/nlua.nvim"
  use "OmniSharp/omnisharp-vim"
  use "nvim-lua/lsp-status.nvim"
  use "hrsh7th/nvim-compe"
  use "hrsh7th/vim-vsnip"
  use "hrsh7th/vim-vsnip-integ"
  use "SirVer/ultisnips"
  use "onsails/lspkind-nvim"
  use "glepnir/lspsaga.nvim"
  use "RRethy/vim-illuminate"
  use "windwp/nvim-autopairs"

  -- Misc
  use {"fatih/vim-go", run = ":GoUpdateBinaries", ft = "go"}
  use "tomtom/tcomment_vim"
  use "tpope/vim-eunuch"
  use "tpope/vim-abolish"

  -- Treesitter
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/playground"
end)

require("jacobfoard.autocommands")
require("jacobfoard.go")
require("jacobfoard.keys")
require("jacobfoard.lsp")
require("jacobfoard.misc")
require("jacobfoard.setup")
require("jacobfoard.statusline")
require("jacobfoard.telescope")
require("jacobfoard.tmux")
require("jacobfoard.tree")
require("jacobfoard.treesitter")
require("jacobfoard.vim")

