local utils = require("utils")

local autocmds = {
  fastlane = {
    {"BufNewFile,BufRead", "Appfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Deliverfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Fastfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Gymfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Matchfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Snapfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Scanfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "Pluginfile", "set ft=ruby"},
    {"BufNewFile,BufRead", "build.lego", "set ft=yaml"},
  },
  format = {
    {"BufWritePost", "*.tf", ":TerraformFmt"},
    {"BufWritePost", "*.pkr.hcl", ":PackerFmt"}
  },
  misc = {
    {"FileType", "gitcommit,gitrebase,gitconfig", "set bufhidden=delete"},
    {"TextYankPost", "*", "silent! lua vim.highlight.on_yank()"},
    {"TermOpen", "*", "setlocal nonu"},
  },
  onmisharp = {
    {"FileType", "cs", "nmap <buffer> gd <Plug>(omnisharp_go_to_definition)"},
    {"FileType", "cs", "nmap <buffer> rn <Plug>(omnisharp_rename)"},
  }
}

utils.nvim_create_augroups(autocmds)
