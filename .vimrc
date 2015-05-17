let mapleader = "\<Space>"
set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin indent on    " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-commentary'
Plugin 'PeterRincker/vim-argumentative'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'justinmk/vim-sneak'
Plugin 'tomasr/molokai'

call vundle#end()

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf = '/home/johkac/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

let g:ctrlp_switch_buffer = 0
let g:ctrlp_by_filename = 1

set tags=./tags;
set completeopt=longest,menuone
set background=dark
colorscheme molokai
syntax on
set autoindent
set tabstop=4 shiftwidth=4 expandtab
set showmatch
set enc=utf-8 fenc=utf8 termencoding=utf-8
set t_Co=256
set hidden
set backspace=indent,eol,start
set ignorecase smartcase
set nohlsearch
set incsearch
set novisualbell noerrorbells
set ruler
set wildignore+=*.o,*.a,*/bin/*
set nofoldenable

function! GenerateTags()
    ! ctags -R --fields=+al --exclude=x_boost_libs .
endfunction
set tags=./tags;

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction

function! GenerateCScope()
    ! find . -name '*.cc' -o -name '*.h' > cscope.files
    ! cscope -RUbq
    call LoadCscope()
endfunction

function! GenerateCScopeNoGtest()
    ! find . -name '*.cc' -not -path "*gtest/*" -o -name '*.h' -not -path "*gtest/*" > cscope.files
    ! cscope -RUbq
    call LoadCscope()
endfunction

call LoadCscope()

function! Grepcpp(search)
    execute ":silent grep! -rnP --include=*.cc --include=*.h --exclude-dir=bin . -e \"" . a:search . "\"" |cwindow
    execute "normal \<C-L>"
endfunction
command! -nargs=1 Grepcpp call Grepcpp(<f-args>)

function! Greppy(search)
    execute ":silent grep! -rnP --include=*.py --exclude-dir=bin . -e " . a:search . " " |cwindow
    execute "normal \<C-L>"
endfunction
command! -nargs=1 Greppy call Greppy(<f-args>)

function! CommandSneakForwards()
    execute "normal v"
    execute ":call sneak#wrap('', 2, 0, 1, 0)"
    execute "normal l"
endfunction

function! CommandSneakBackwards()
    execute "normal v"
    execute ":call sneak#wrap('', 2, 1, 1, 0)"
endfunction


nnoremap <F1> :call GenerateTags()<CR>
nnoremap <F2> :call GenerateCScope()<CR>
nnoremap <F3> :call Grepcpp(expand("<cword>"))<CR>
nnoremap <F4> :call GenerateCScopeNoGtest()<CR>
noremap <F5> :call Svndiff("prev")<CR>
noremap <F6> :call Svndiff("next")<CR>
noremap <F7> :call Svndiff("clear")<CR>
noremap <F9> :vne<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
nnoremap <Leader>f :CtrlP .<CR>
nnoremap <Leader>F :CtrlP .<CR><C-d>
nnoremap <Leader>b :CtrlPBuffer<CR>

nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S
xmap f <Plug>Sneak_s
xmap F <Plug>Sneak_S
omap f :call CommandSneakForwards()<CR>
omap F :call CommandSneakBackwards()<CR>

vmap > >gv
vmap < <gv  

inoremap jk <Esc>
cnoremap jk <C-c>
nnoremap H ^
nnoremap L $
nnoremap <Enter> o<Esc>
nnoremap <Leader><Enter> O<Esc>
nnoremap <Leader>+ :set paste<CR>"+p:set nopaste<CR>
nnoremap <Leader>- :set paste<CR>"+P:set nopaste<CR>
nnoremap <Leader>d "add
nnoremap <Leader>y "ayy
vnoremap <Leader>d "ad
vnoremap <Leader>y "ay
nnoremap <Leader>p "ap
nnoremap <Leader>P "aP
nnoremap <Leader>/ /<C-r><C-w>
nnoremap <Leader>? ?<C-r><C-w>
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nnoremap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nnoremap <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nnoremap <Leader>, :Commentary<CR>
vnoremap <Leader>, :Commentary<CR>
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>
nnoremap <Leader>j J
nnoremap <Leader>? ?{\\|}<CR>
nnoremap <Leader>/ /{\\|}<CR>
nnoremap J 20j
nnoremap K 20k
vnoremap J 20j
vnoremap K 20k
nnoremap <Leader>w :w<CR>
