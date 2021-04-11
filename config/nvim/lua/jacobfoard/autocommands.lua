local utils = require("utils")

local autocmds = {
  misc = {
    {"FileType", "gitcommit,gitrebase,gitconfig", "set bufhidden=delete"},
    {"TextYankPost", "*", "silent! lua vim.highlight.on_yank()"},
    {"TermOpen", "*", "setlocal nonu"},
  },
  onmisharp = {
    -- {"FileType", "cs", "nmap <buffer> gd <Plug>(omnisharp_go_to_definition)"},
    -- {"FileType", "cs", "nmap <buffer> rn <Plug>(omnisharp_rename)"},
  },
  format = {
    {"BufWritePost", "*.nix", ":NixFmt"},
    {"BufWritePost", "*.pkr.hcl", ":PackerFmt"}
  },
}

utils.nvim_create_augroups(autocmds)
