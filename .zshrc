source ~/.zsh/init.zsh

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias zsh_reset="rm -rf ~/.zsh/config.zsh ~/.zsh/antigen.zsh"
alias mv="mv -i"

export SSH_AUTH_SOCK="/run/user/1000/ssh-agent.socket"
export PATH=~/go/bin:$PATH
export EDITOR=vim

mcd () {
    mkdir -p "$1"
    cd "$1"
}
