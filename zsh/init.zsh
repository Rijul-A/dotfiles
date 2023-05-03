# Start by downloading antigen, the zsh plugin manager
if [[ ! -e ~/.zsh/antigen.zsh ]]; then
  echo "Downloading missing antigen.zsh"
  curl --silent -L git.io/antigen > ~/.zsh/antigen.zsh
fi
# Source it
source ~/.zsh/antigen.zsh
# Load the oh-my-zsh library
antigen use oh-my-zsh
# Autocompletion
antigen bundle adb
antigen bundle docker
antigen bundle docker-compose
antigen bundle golang
antigen bundle pip
antigen bundle ufw
antigen bundle yarn
# The prompt shown in a git folder outlining the number of files / commits / branch
antigen bundle git-prompt
# Autocompletion for pipenv, and automatic (de)activation
antigen bundle pipenv
# `mkv` and `vrun` to make and activate virtual environments
antigen bundle python
# Suggests packages to install
antigen bundle command-not-found
# Create new `lwd` alias, and auto `cd` in new temrinals
antigen bundle last-working-dir
# Cat an image
antigen bundle catimg
# `cpv` alias rsync with good defaults
antigen bundle cp
# Type in `ls -l fol` and press up for `ls -l fold` and `ls -l folder` as results
antigen bundle history-substring-search
# `ccat` alias for syntax highlighting
antigen bundle colorize
# Extract any archive with one command: `extract asd`
antigen bundle extract
# Auto load `.env` files
antigen bundle dotenv
# Use `gi java >> .gitignore` to add appropriate filters
antigen bundle gitignore
# Commands to execute on empty shell + Enter
MAGIC_ENTER_GIT_COMMAND='git status'
MAGIC_ENTER_OTHER_COMMAND='ls --color=auto -lh'
antigen bundle magic-enter
# Ignore any newlines within a pasted command 
antigen bundle safe-paste
# Auto correction, but requires `pip install thefuck`
antigen bundle thefuck
# Multiplexer
ZSH_TMUX_AUTOSTART=true # always start tmux
if [[ "${XDG_SESSION_TYPE}" == "tty" ]]; then
  ZSH_TMUX_AUTOSTART=false # unless over ssh
fi
ZSH_TMUX_UNICODE=true # support pretty characters
ZSH_TMUX_AUTOCONNECT=false # retain new tab support
antigen bundle tmux
# Cool version of cd
antigen bundle zsh-interactive-cd
# History based auto suggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
antigen bundle zsh-users/zsh-autosuggestions
# Fancy git diff, enable it in ~/.gitconfig
antigen bundle z-shell/zsh-diff-so-fancy@main
# Binary not found is red in color
antigen bundle zsh-users/zsh-syntax-highlighting
# Theme compatible with p10k.zsh
antigen theme romkatv/powerlevel10k
antigen apply

# Shell configuration options
if [[ ! -e ~/.zsh/config.zsh ]]; then
  echo "Downloading missing config.zsh"
  curl --silent -L https://raw.githubusercontent.com/Rijul-A/manjaro-zsh-config/master/manjaro-zsh-config > ~/.zsh/config.zsh
fi
source ~/.zsh/config.zsh

# Theme configuration options
if [[ ! -e ~/.zsh/p10k.zsh ]]; then
  echo "Downloading missing p10k.zsh"
  curl --silent -L https://raw.githubusercontent.com/Rijul-A/manjaro-zsh-config/master/p10k.zsh > ~/.zsh/p10k.zsh
fi
source ~/.zsh/p10k.zsh
