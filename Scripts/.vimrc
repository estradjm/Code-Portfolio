set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'

let python_highlight_all=1
syntax on

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


set modeline
set undofile
set laststatus=2
set splitbelow
set splitright
set number
set ignorecase
set incsearch
set hlsearch
set dictionary=/usr/share/dict/words
set mouse=a
set showmatch

autocmd FileType python noremap <buffer> <F4> :exec '!python' shellescape(@%, 1)<CR>

set background=dark
set encoding=utf-8

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
