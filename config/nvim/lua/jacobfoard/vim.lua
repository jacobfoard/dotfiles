-- Generic Vim Code that isn't easily represented in lua
vim.api.nvim_exec(
    [[
function! NixFmt()
  silent execute '!nixpkgs-fmt %'
  silent edit!
endfunction

function! PackerFmt()
  silent execute '!packer fmt -write=true %'
  silent edit!
endfunction

function! BazelFmt()
  silent execute '!buildifier %'
  silent edit!
endfunction

command! BazelFmt call BazelFmt()
command! NixFmt call NixFmt()
command! PackerFmt call PackerFmt()
command! OpenDiagnostics lua vim.lsp.diagnostic.set_loclist()
command! Spectre lua require('spectre').open()

function! TermCD()
  let currDir = getcwd()
  let newDir = expand("%:p:h")
  execute 'lcd '.newDir
  execute 'terminal'
  execute 'lcd '.currDir
endfunction

command! T split | call TermCD()
command! VT vsplit | call TermCD()
command! Q quit
command! QA qall
command! Qa qall
command! W write
command! WA wall
command! Wa wall
command! WQ wq
command! Wq wq
command! WQa wqall
command! Wqa wqall
command! VS vsplit
command! Vs vsplit
]],
    true
)
