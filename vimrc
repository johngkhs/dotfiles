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
Plugin 'justinmk/vim-sneak'
Plugin 'tomasr/molokai'
Plugin 'yssl/QFEnter'
Plugin 'johngkhs/vim-togglelist'
Plugin 'johngkhs/CamelCaseMotion'
Plugin 'alvan/vim-closetag'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'stefandtw/quickfix-reflector.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'jeetsukumaran/vim-filebeagle'
Plugin 'haya14busa/incsearch.vim'
Plugin 'tpope/vim-repeat'
Plugin 'Yggdroot/indentLine.git'
Plugin 'lyuts/vim-rtags'
Plugin 'eaglemt/neco-ghc'

call vundle#end()
filetype plugin indent on
runtime macros/matchit.vim

syntax on
colorscheme molokai
set background=dark
set tags=./tags;
set completeopt=longest,menuone
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

set grepprg=ag\ --nogroup\ --nocolor
nnoremap <Leader>s :silent execute "grep! --cpp " . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>
command! -nargs=+ Grepcpp :silent execute "grep! --cpp " shellescape(<q-args>) " ." | :copen
command! -nargs=+ Greppy :silent execute "grep! --py " shellescape(<q-args>) " ." | :copen

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf = "$HOME/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py"
let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_confirm_extra_conf = 0

let g:sneak#use_ic_scs = 1
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
nnoremap <Leader>f :CtrlP .<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

let g:closetag_filenames = "*.xml"

let g:qfenter_open_map = ['<C-q>']
let g:toggle_list_no_mappings = 1
nmap <script> <silent> <Leader>a :call ToggleQuickfixList()<CR>

let g:necoghc_enable_detailed_browse = 1

let b:fswitchdst = 'h,hpp'
nmap <silent> <Leader>h :FSHere<CR>

let g:filebeagle_suppress_keymaps = 1
map <silent> <Leader>-  <Plug>FileBeagleOpenCurrentWorkingDir
map <silent> - <Plug>FileBeagleOpenCurrentBufferDir

let g:incsearch#separate_highlight = 1
highlight IncSearchMatch ctermbg=87 ctermfg=0
highlight IncSearchMatchReverse ctermbg=219 ctermfg=0
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)

let g:indentLine_color_term = 245
let g:indentLine_char = '│'

let g:rtagsUseLocationList = 0
let g:rtagsUseDefaultMappings = 0
nnoremap <Enter> :call rtags#JumpTo()<CR>
nnoremap <Leader><Enter> :call rtags#FindRefs()<CR>
nnoremap <Leader><Leader><Enter> g<C-]>

nmap <Left> <Plug>Argumentative_MoveLeft
nmap <Right> <Plug>Argumentative_MoveRight

omap <silent> au <Plug>CamelCaseMotion_iw
xmap <silent> au <Plug>CamelCaseMotion_iw
omap <silent> iu <Plug>CamelCaseMotion_ie
xmap <silent> iu <Plug>CamelCaseMotion_ie

nnoremap <Leader>, :Commentary<CR>
vnoremap <Leader>, :Commentary<CR>

set clipboard=unnamedplus
nnoremap <Leader>P O<Space><Backspace><Esc>:set paste<CR>p:set nopaste<CR>
nnoremap <Leader>p o<Space><Backspace><Esc>:set paste<CR>p:set nopaste<CR>

inoremap jk <Esc>
cnoremap jk <C-c>

map J 20j
map K 20k

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap H <C-O>
nnoremap L <C-I>

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <Tab> >>
nnoremap <S-Tab> <<

nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <Leader>R :%s/\<<C-r><C-w>\>//g<Left><Left>
vnoremap <Leader>r y:%s/<C-r>"//gc<Left><Left><Left>
vnoremap <Leader>R y:%s/<C-r>"//g<Left><Left><Left>

nnoremap <Leader>d "_d
vnoremap <Leader>d "_d
nnoremap <Leader>x "_x
vnoremap <Leader>x "_x
nnoremap <Leader>c "_c
vnoremap <Leader>c "_c

nnoremap <Leader>J mzJ`z

nnoremap <Leader>E :vsplit $MYVIMRC<CR>
nnoremap <Leader>S :source $MYVIMRC<CR>

nnoremap <Backspace> g;
nnoremap <Leader><Backspace> g,

nnoremap Y y$

augroup save_clipboard_contents_on_exit
    autocmd!
    autocmd VimLeave * call system("xclip -in -selection clipboard", getreg('+'))
augroup END

augroup strip_trailing_whitespace_on_save
    autocmd!
    autocmd FileType cpp autocmd BufWritePre <buffer> StripWhitespace
augroup END

augroup cpp_header_file_switching
  autocmd!
  autocmd BufEnter *.cc let b:fswitchdst = 'h'
  autocmd BufEnter *.h let b:fswitchdst = 'cc'
augroup END

augroup fullscreen_quickfix
  autocmd!
  autocmd BufReadPost quickfix nmap <buffer> <CR> <C-q>:ccl<CR><C-w>=
  autocmd BufReadPost quickfix nnoremap <buffer> <Tab> j
  autocmd BufReadPost quickfix nnoremap <buffer> <S-Tab> k
  autocmd FileType qf wincmd J
  autocmd FileType qf wincmd _
augroup END

augroup haskell_completion
  autocmd!
  autocmd FileType haskell set omnifunc=necoghc#omnifunc
augroup END

function! GenerateTags()
    ! ctags -R --fields=+al .
    set tags=./tags;
endfunction
nnoremap <F1> :call GenerateTags()<CR>
