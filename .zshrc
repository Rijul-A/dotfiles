export PATH=~/.local/share/gem/ruby/3.0.0/bin:~/.local/bin:~/go/bin:/usr/local/go/bin:$PATH
export EDITOR=vim
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
# download Go modules from hosts instead of via Google
export GOPROXY="direct"
# prevent creation of ~/.lesshst
export LESSHISTFILE=-
export GPG_TTY=$(tty)

source ~/.zsh/init.zsh

alias dotfiles="TZ=UTC /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias zsh_reset="rm -rf ~/.zsh/config.zsh ~/.zsh/antigen.zsh"
alias mv="mv -i"
alias git="TZ=UTC /usr/bin/git"
alias userctl="/usr/bin/systemctl --user"

TZ=UTC /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no

if which keepassxc > /dev/null 2>&1 ; then
    export SSH_AUTH_SOCK="/run/user/1000/ssh-agent.socket"
fi

mcd () {
    mkdir -p "$1"
    cd "$1"
}

gitRemoteToSSH () {
    existing=$(git config remote.origin.url)
    if [ -z "$existing" ]; then echo "Could not figure out existing url"; return; fi
    if grep -q "git@" <<< "$existing"; then echo "No change needed"; return; fi
    # replace HTTPS:// with git@
    replaced=$(echo "$existing" | sed "s/https:\/\//git@/")
    # now replace first slash with :
    replaced=$(echo "$replaced" | sed "s/\//:/")
    git config remote.origin.url "$replaced"
    echo "Changed to $(git config remote.origin.url)"
}
gitRemoteToHTTPS () {
    existing=$(git config remote.origin.url)
    if [ -z "$existing" ]; then echo "Could not figure out existing url"; return; fi
    if grep -q "https://" <<< "$existing"; then echo "No change needed"; return; fi
    replaced=$(echo "$existing" | sed "s/git@/https:\/\//")
    replaced=$(echo "$replaced" | sed "s/:/\//2")
    git config remote.origin.url "$replaced"
    echo "Changed to $(git config remote.origin.url)"
}

eval $(thefuck --alias)

if [[ -e ~/.zsh/additional.zsh ]]; then
    source ~/.zsh/additional.zsh
fi
