local utils = require("utils")

local autocmds = {
    misc = {
        { "FileType", "gitcommit,gitrebase,gitconfig", "set bufhidden=delete" },
        { "TextYankPost", "*", "silent! lua vim.highlight.on_yank()" },
        { "TermOpen", "*", "setlocal nonu" },
        -- { "BufNewFile,BufRead", "*.json", "set filetype=jsonc" },
        { "BufNewFile,BufRead", "*.*.hcl", "setlocal filetype=hcl" },
    },
    format = {
        { "BufWritePost", "*.nix", ":NixFmt" },
        { "BufWritePost", "*.bzl,*.bazel,BUILD,WORKSPACE", ":BazelFmt" },
    },
}

utils.nvim_create_augroups(autocmds)
