# this will download everything, if it does not exist
if [[ ! -e ~/.zsh/antigen.zsh ]]; then
  echo "Downloading missing antigen.zsh"
  curl --silent -L git.io/antigen > ~/.zsh/antigen.zsh
fi
source ~/.zsh/antigen.zsh
MAGIC_ENTER_GIT_COMMAND='git status'
MAGIC_ENTER_OTHER_COMMAND='ls --color=auto -lth'
antigen use oh-my-zsh
antigen bundle adb
antigen bundle git
antigen bundle git-prompt
antigen bundle pip
antigen bundle pipenv # auto (de)activate
antigen bundle python
antigen bundle command-not-found
antigen bundle docker
antigen bundle docker-compose
antigen bundle golang
antigen bundle last-working-dir # for new shell
antigen bundle jsontools # cat file.json | pp_json
antigen bundle catimg # show image
antigen bundle cp # nice cp
antigen bundle history-substring-search
antigen bundle colorize # ccat file
antigen bundle extract # generic extract for all
antigen bundle dotenv # auto load .env
antigen bundle gitignore # add from API
antigen bundle magic-enter # Blank enter => command
antigen bundle safe-paste # no Enter without consent
antigen bundle thefuck # two escapes => get sudo
antigen bundle yarn
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle z-shell/zsh-diff-so-fancy@main
antigen theme romkatv/powerlevel10k
antigen apply
if [[ ! -e ~/.zsh/config.zsh ]]; then
  echo "Downloading missing config.zsh"
  curl --silent -L https://raw.githubusercontent.com/Rijul-A/manjaro-zsh-config/master/manjaro-zsh-config > ~/.zsh/config.zsh
fi
source ~/.zsh/config.zsh
if [[ ! -e ~/.zsh/p10k.zsh ]]; then
  echo "Downloading missing p10k.zsh"
  curl --silent -L https://raw.githubusercontent.com/Rijul-A/manjaro-zsh-config/master/p10k.zsh > ~/.zsh/p10k.zsh
fi
source ~/.zsh/p10k.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
