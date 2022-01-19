source ~/.zsh/init.zsh

alias dotfiles="TZ=UTC /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias zsh_reset="rm -rf ~/.zsh/config.zsh ~/.zsh/antigen.zsh"
alias mv="mv -i"
alias git="TZ=UTC /usr/bin/git"

TZ=UTC /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no

export SSH_AUTH_SOCK="/run/user/1000/ssh-agent.socket"
export PATH=~/.local/bin:~/go/bin:$PATH
export EDITOR=vim
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

mcd () {
    mkdir -p "$1"
    cd "$1"
}
