local autocmds = {
    { "FileType", "gitcommit,gitrebase,gitconfig", "set bufhidden=delete" },
    { "TextYankPost", "*", "silent! lua vim.highlight.on_yank()" },
    { "TermOpen", "*", "setlocal nonu" },
    -- { "BufNewFile,BufRead", "*.json", "set filetype=jsonc" },
    { "BufNewFile,BufRead", "*.*.hcl", "setlocal filetype=hcl" },
    { "BufWritePost", "*.nix", ":NixFmt" },
    { "BufWritePost", "*.bzl,*.bazel,BUILD,WORKSPACE", ":BazelFmt" },
}

-- TODO: Maybe make this cleaner
for _, v in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(
        v[1], -- event
        -- opts
        {
            pattern = v[2],
            command = v[3],
        }
    )
end
