local opt = vim.api.nvim_command

for _, value in pairs(vim.fn.getcompletion("", "color")) do
  if value == "codedark" then
    vim.g.colors_name = "codedark"
  end
end


opt("set termguicolors")
opt("syntax on")
opt("set clipboard+=unnamedplus")
opt("set autowrite")
opt("set autoread")
opt("set tabstop=2 shiftwidth=2 expandtab")
opt("set noshowmode")
opt("set number")
opt("set mouse+=a")
opt("set number")
opt("set backspace=indent,eol,start")
opt("set splitbelow")
opt("set splitright")
opt("set noswapfile")
opt("set nobackup")
opt("set ignorecase")
opt("set completeopt=menuone,noselect")
opt("set shortmess+=c")
opt("set nowrap")
opt("set ttyfast")
opt("set hidden")
opt("set undodir=~/.config/nvim/vim-persisted-undo")
opt("set undofile")
opt("set termguicolors")
opt("set inccommand=split")
opt("set updatetime=500 ")
opt("set viminfo='100,<1000,s10,h")

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
vim.env.EDITOR = "nvr -cc split --remote-wait"
