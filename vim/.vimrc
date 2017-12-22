" .vimrc " written by Evan Cook
"
" My personal .vimrc file for nothing really in particular (yet!)
"
" Largely inspired by Steve Losh's 'Learn Vimscript the Hard Way'
" tutorial (http://learnvimscriptthehardway.stevelosh.com/)


" Plugins --------------------- {{{

set nocompatible
filetype off

" Set runtime path
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin manager
Plugin 'gmarik/Vundle.vim'

" Python folding/indenting
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'

" Better window swapping
Plugin 'wesQ3/vim-windowswap'

" R plugin
" Plugin 'jalvesaq/Nvim-R'

" Syntax checker
Plugin 'scrooloose/syntastic'

" Save Ctags automatically (on Git commits I beleive)
" Plugin 'craigemery/vim-autotag'

" Ruby folding
Plugin 'vim-utils/vim-ruby-fold'

" HTML tagging
Plugin 'mattn/emmet-vim'

call vundle#end()

" To install, run :PluginInstall "


" Plugin-Specific --------------------- {{{

" SimplyFold --------------------- {{{

autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

" }}}

" Syntastic ---------------------- {{{

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "level": "warnings" }

" }}}

" }}}


" }}}


" Appearance --------------------- {{{

filetype plugin indent on

" Colors
colorscheme jellybeans
syntax enable

" Tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" UI Config
set number
set showcmd
set showmatch

" Search Highlighting
set hlsearch incsearch
nnoremap <leader><esc> :noh<cr>
nohlsearch

highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" Search shortcuts
nnoremap <leader>/ <c-o>
nnoremap / ms/
nnoremap * ms*
nmap <leader>bb /byebug<cr>

" Always show status line
set laststatus=2

" More natural split opening
set splitbelow
set splitright

" Status Line
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines

set nowrap

" }}}


" Mappings --------------------- {{{

" Misc --------------------- {{{

let mapleader=","
let maplocalleader="\\"

" Copy/paste from system cliipboard
inoremap <c-v> <esc>"*pA
nnoremap <c-v> "pA<esc>
vnoremap <c-c> "+y
nnoremap <c-y> "+Y

" Quick folding
nnoremap <space> za

" Show buffers
nnoremap <leader>b :ls<cr>

" Open previous buffer in new window
nnoremap <leader>pb :execute "split " . bufname("#")<cr>

" }}}

" Normal Mode --------------------- {{{

" Quick vimrc editing/saving
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>evc :split ~/.vim/ftplugin/c.vim<cr>

" Better Redo
nnoremap U <c-r>

" 'Stronger Navigation
nnoremap H I<esc>
nnoremap L A<esc>
nnoremap J <c-d>
nnoremap K <c-u>

" Window navigation
nnoremap <leader>h <c-w>h
nnoremap <leader>l <c-w>l
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k

" Tab navigation
nnoremap <leader>H gT
nnoremap <leader>L gt
nnoremap <leader>J :tablast
nnoremap <leader>K :tabfirst

" Window resizing
nnoremap <c-H> <c-w><
nnoremap <c-J> <c-w>-
nnoremap <c-K> <c-w>+
nnoremap <c-L> <c-w>>

" New blank line below/above
nnoremap <leader>J m`o<esc>``
nnoremap <leader>K m`O<esc>``

" Quote word
nnoremap <leader>" ea"<esc>bi"<esc>el

" make word lower/uppercase
nnoremap <leader>U lbviwUe
nnoremap <leader>u lbviwue

" comment line (TODO make specific to filetype)
nnoremap <leader>/ 0i#<esc>

" }}}

" Insert Mode --------------------- {{{

" Back to normal mode faster
inoremap jk <esc>

" Go to beginning/end of line
inoremap <c-j> <esc>I
inoremap <c-l> <esc>A

" Delete line
inoremap <c-d> <esc>dd

" Make word all caps
inoremap <c-u> <esc>bviwUe

" }}}

" }}}


" Filetype-Specific --------------------- {{{

" R --------------------- {{{
augroup filetype_R
    autocmd!

    " Set correct tabstops
    autocmd FileType R setlocal tabstop=2
    autocmd FileType R setlocal softtabstop=2
    autocmd FileType R setlocal shiftwidth=2

augroup END
" }}}


" }}}
