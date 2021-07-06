local utils = require("utils")

local autocmds = {
  misc = {
    {"FileType", "gitcommit,gitrebase,gitconfig", "set bufhidden=delete"},
    {"TextYankPost", "*", "silent! lua vim.highlight.on_yank()"},
    {"TermOpen", "*", "setlocal nonu"},
    {"BufNewFile,BufRead", "*.json", "setlocal filetype=jsonc"},
    {"BufNewFile,BufRead", "*.pkr.hcl", "setlocal filetype=hcl"},
  },
  format = {
    {"BufWritePost", "*.nix", ":NixFmt"},
    {"BufWritePost", "*.pkr.hcl", ":PackerFmt"},
    {"BufWritePost", "*.bzl,*.bazel,BUILD,WORKSPACE", ":BazelFmt"},
  },
}

utils.nvim_create_augroups(autocmds)
