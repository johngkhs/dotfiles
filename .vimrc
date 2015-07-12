let mapleader = "\<Space>"
set nocompatible
filetype off
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
Plugin 'yssl/QFEnter'
Plugin 'milkypostman/vim-togglelist'
Plugin 'bkad/CamelCaseMotion'
Plugin 'dkprice/vim-easygrep'
Plugin 'alvan/vim-closetag'
Plugin 'jeetsukumaran/vim-indentwise'
Plugin 'jiangmiao/auto-pairs'
" Plugin 'raichoo/haskell-vim'
" Plugin 'eaglemt/neco-ghc'
" Plugin 'scrooloose/syntastic'

call vundle#end()
filetype plugin indent on

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_global_ycm_extra_conf = '/home/johkac/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_confirm_extra_conf = 0

let g:ctrlp_switch_buffer = 0
let g:ctrlp_by_filename = 1
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_match_window = 'bottom,order:ttb,min:15,max:15,results:15'
let g:ctrlp_prompt_mappings =
\ { 
\   'PrtSelectMove("j")': ['<down>', '<tab>'] ,
\   'PrtSelectMove("k")': ['<up>', '<s-tab>'],
\   'PrtExpandDir()': [],
\   'ToggleFocus()': [],
\ } 

let g:AutoPairsShortcutToggle = '<Leader>P'

let g:sneak#use_ic_scs = 1

let g:necoghc_enable_detailed_browse = 1
let $PATH = $PATH . ':' . expand("/Users/john/Library/Haskell/bin")
autocmd FileType haskell set omnifunc=necoghc#omnifunc

let g:qfenter_open_map = ['<C-q>']
let g:toggle_list_no_mappings = 1
nmap <script> <silent> <Leader>a :call ToggleQuickfixList()<CR>
autocmd BufReadPost quickfix nmap <buffer> <CR> <C-q>:ccl<CR><C-w>=
autocmd BufReadPost quickfix nnoremap <buffer> <Tab> j
autocmd BufReadPost quickfix nnoremap <buffer> <S-Tab> k
autocmd FileType qf wincmd J
autocmd FileType qf wincmd _

set grepprg=ag\ --nogroup\ --nocolor
nnoremap <Leader>s :silent execute "grep! --cpp " . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>
command! -nargs=+ Grepcpp :silent execute "grep! --cpp " shellescape(<q-args>) " ." | :copen

syntax on
colorscheme molokai
set tags=./tags;
set completeopt=longest,menuone
set background=dark
set autoindent
set tabstop=4 shiftwidth=4 expandtab
set showmatch
set enc=utf-8 fenc=utf8 termencoding=utf-8
set t_Co=256
set hidden
set backspace=indent,eol,start
set ignorecase smartcase
set nohlsearch incsearch
set novisualbell noerrorbells
set ruler
set wildignore+=*.o,*.a,*/bin/*
set nofoldenable
set lazyredraw ttyfast
set number relativenumber
set laststatus=2

function! GenerateTags()
    ! ctags -R --fields=+al --exclude=x_boost_libs .
    set tags=./tags;
endfunction

nnoremap <F1> :call GenerateTags()<CR>
noremap <F5> :call Svndiff("prev")<CR>
noremap <F6> :call Svndiff("next")<CR>
noremap <F7> :call Svndiff("clear")<CR>
noremap <F9> :vne<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

nnoremap <Leader>f :CtrlP .<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
omap s v<Plug>Sneak_s
omap S v<Plug>Sneak_S

nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F v<Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T v<Plug>Sneak_T

map - <Plug>CamelCaseMotion_w
map _ <Plug>CamelCaseMotion_b
map + <Plug>CamelCaseMotion_e

omap <silent> a- <Plug>CamelCaseMotion_iw
xmap <silent> a- <Plug>CamelCaseMotion_iw
omap <silent> i_ <Plug>CamelCaseMotion_ib
xmap <silent> i_ <Plug>CamelCaseMotion_ib
omap <silent> i- <Plug>CamelCaseMotion_ie
xmap <silent> i- <Plug>CamelCaseMotion_ie

nmap <Left> <Plug>Argumentative_MoveLeft
nmap <Right> <Plug>Argumentative_MoveRight

map <silent> <Leader>R <Plug>EgMapReplaceCurrentWord_r
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

inoremap jk <Esc>
cnoremap jk <C-c>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nnoremap <Leader>p :set paste!<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap H <C-O>
nnoremap L <C-I>
noremap <silent> J :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
noremap <silent> K :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv  
nnoremap <Tab> >>
nnoremap <S-Tab> <<

nnoremap <Enter> g<C-]>

nnoremap <Leader>d "_d
vnoremap <Leader>d "_d
nnoremap <Leader>x "_x
vnoremap <Leader>x "_x
nnoremap <Leader>c "_c
vnoremap <Leader>c "_c

nnoremap <Leader>j J

nnoremap <Leader>E :vsplit $MYVIMRC<CR>
nnoremap <Leader>S :source $MYVIMRC<CR>

nnoremap <Leader>, :Commentary<CR>
vnoremap <Leader>, :Commentary<CR>

function! IndentWiseDifferentIndent(next)
    if a:next == 1
        let s:lesser_indent_cmd = "\<Plug>(IndentWiseNextLesserIndent)"
        let s:greater_indent_cmd = "\<Plug>(IndentWiseNextGreaterIndent)"
    else
        let s:lesser_indent_cmd = "\<Plug>(IndentWisePreviousLesserIndent)"
        let s:greater_indent_cmd = "\<Plug>(IndentWisePreviousGreaterIndent)"
    endif

    let s:curr_y = getpos('.')[1]
    execute "keepjumps normal " . s:lesser_indent_cmd
    let s:lesser_indent_y = getpos('.')[1]
    execute "keepjumps normal! " . s:curr_y . "G"
    execute "keepjumps normal " . s:greater_indent_cmd
    let s:greater_indent_y=getpos('.')[1]

    if s:lesser_indent_y == s:curr_y
        execute "keepjumps normal! " . s:greater_indent_y . "G"
    elseif s:greater_indent_y == s:curr_y
        execute "keepjumps normal! " . s:lesser_indent_y . "G"
    else
        let s:closer_y = a:next == 1 ? min([s:lesser_indent_y, s:greater_indent_y]) :  max([s:lesser_indent_y, s:greater_indent_y])
        execute "keepjumps normal! " . s:closer_y  . "G"
    endif
endfunction

noremap <silent> } :<C-u>execute "keepjumps norm! /{\<lt>CR>/\\S\<lt>CR>"<CR>
noremap <silent> { :<C-u>execute "keepjumps norm! 2?{\<lt>CR>/\\S\<lt>CR>"<CR>
noremap <silent> ) :<C-u>execute "keepjumps norm! /(\<lt>CR>/\\S\<lt>CR>"<CR>
noremap <silent> ( :<C-u>execute "keepjumps norm! 2?(\<lt>CR>/\\S\<lt>CR>"<CR>
map <silent> > :call IndentWiseDifferentIndent(1)<CR>
map <silent> < :call IndentWiseDifferentIndent(0)<CR>
