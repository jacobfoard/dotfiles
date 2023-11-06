zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache-path
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
# EDITOR="nvim"

# adapted from https://github.com/spwhitt/nix-zsh-completions/issues/32#issuecomment-705315356
function _nix() {
  local ifs_bk="$IFS"
  local input=("${(Q)words[@]}")
  IFS=$'\n'$'\t'
  local res=($(NIX_GET_COMPLETIONS=$((CURRENT - 1)) "$input[@]"))
  IFS="$ifs_bk"
  local tpe="$res[1]"
  local suggestions=(${res:1})
  if [[ "$tpe" == filenames ]]; then
    compadd -fa suggestions
  else
    compadd -a suggestions
  fi
}

# export PATH=$PATH:$(go env GOPATH)/bin

compdef _nix nix
source ~/.config/zsh/p10k.zsh
source ~/.config/zsh/work.zsh

flakifiy() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:jacobfoard/dotfiles .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-vim} flake.nix
}

gh () {
  if [[ -n $1 ]]
  then
    /usr/bin/env gh "$@"
  else
    ~/code/github.com
  fi
}


[ -n "$WEZTERM_PANE" ] && export NVIM_LISTEN_ADDRESS="/tmp/nvim$WEZTERM_PANE"
