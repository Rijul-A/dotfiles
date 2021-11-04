setopt histignorespace  # not used upstream
source .zsh/init.zsh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias zsh_reset='rm -rf ~/.zsh/config.zsh ~/.zsh/antigen.zsh'
export SSH_AUTH_SOCK="/run/user/1000/ssh-agent.socket"
export PATH=~/go/bin:$PATH
mcd () {
    mkdir -p "$1"
    cd "$1"
}
