if !isdirectory($HOME . "/.vim/backup")
    call mkdir($HOME . "/.vim/backup", "p")
endif

if !isdirectory($HOME . "/.vim/backupf")
    call mkdir($HOME . "/.vim/backupf", "p")
endif

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
call plug#end()

set nocompatible
set autoread
autocmd! bufwritepost vimrc source ~/.vim/vimrc
set title
set encoding=utf-8
set backupdir=~/.vim/backup
set directory=~/.vim/backupf
set showcmd
set mouse=a
set number
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40
set cursorcolumn
set whichwrap=bs<>[]
set laststatus=2
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\ 	exe "normal g`\"" |
	\ endif
set showbreak=>\ \ \
set ofu=syntaxcomplete#Complete
set ttyfast
"Search options
set wildignorecase
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
"Indent options
set copyindent
set smarttab
set autoindent
set smartindent
"Language specific
filetype plugin indent on
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby
au BufRead,BufNewFile *.html.erb set ft=eruby
au BufNewFile,BufRead *.json set ft=json syntax=javascript
