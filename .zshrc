#!/bin/zsh

export GPG_TTY=$(tty)
export CFG=$HOME/.config/jacobfoard

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi


export EDITOR=nvim
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export GOPATH="$HOME/go"
export GO11MODULE=auto
export GOFLAGS="-mod=mod"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="${PATH}:${HOME}/.krew/bin"
export RIPGREP_CONFIG_PATH=$HOME/.config/.ripgreprc
export TMUX_PLUGIN_MANAGER_PATH=$CFG/tmux

export CDPATH=$GOPATH/src

plugins=(gitfast kubectl redis-cli docker terraform gitignore golang fast-syntax-highlighting)

DEFAULT_USER=jacobfoard

source $ZSH/oh-my-zsh.sh
source $CFG/zsh/aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $CFG/zsh/work.zsh ] && source $CFG/zsh/work.zsh
[[ ! -f $CFG/zsh/.p10k.zsh ]] || source $CFG/zsh/.p10k.zsh

[[ -z $NVIM_LISTEN_ADDRESS ]] || export EDITOR="nvr -cc split --remote-wait"

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
