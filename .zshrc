source ~/.zsh/init.zsh

alias dotfiles="TZ=UTC /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias zsh_reset="rm -rf ~/.zsh/config.zsh ~/.zsh/antigen.zsh"
alias mv="mv -i"
alias git="TZ=UTC /usr/bin/git"

TZ=UTC /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no

export SSH_AUTH_SOCK="/run/user/1000/ssh-agent.socket"
export PATH=~/.local/bin:~/go/bin:$PATH
export EDITOR=vim

mcd () {
    mkdir -p "$1"
    cd "$1"
}
