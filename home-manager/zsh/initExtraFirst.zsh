# export GPG_TTY=$(tty)
# if [ -z $IS_REMOTE ]; then
#   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#   gpgconf --launch gpg-agent
# fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
