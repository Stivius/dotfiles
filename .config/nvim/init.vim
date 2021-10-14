let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug '907th/vim-auto-save'
  Plug 'altercation/vim-colors-solarized'
  Plug 'tpope/vim-surround'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'easymotion/vim-easymotion'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

filetype plugin on

" autocommands
autocmd Filetype markdown source ~/.config/nvim/zettelkasten.vim

" let g:auto_save = 1  " enable AutoSave on Vim startup 
" let g:airline_powerline_fonts = 1 " use powerline fonts
let g:Powerline_symbols='unicode' " support unicode

set t_Co=256
set background=light

" enable russian layout
set keymap=russian-jcukenwin  
set iminsert=0 " default - enlgish
set imsearch=0 " default - english
inoremap <C-Space> <C-^>
nnoremap <C-Space> a<C-^><ESC>
highlight lCursor guifg=NONE guibg=Cyan

set wrap linebreak " wrap words
set tabstop=4
set shiftwidth=4
set relativenumber
set number
set encoding=UTF-8
set autoindent
set splitright " for vnew to work to the right 

" change <Leader> key
nnoremap <SPACE> <Nop>
let mapleader=" "

" search
noremap <F9> :nohl<CR>
noremap <F8> :set ignorecase! ingorecase?<CR>

"map <Leader> <Plug>(easymotion-prefix)
nmap f <Plug>(easymotion-fl)
nmap F <Plug>(easymotion-Fl)
nmap <Leader><Leader>f <Plug>(easymotion-f2)
nmap <Leader><Leader>F <Plug>(easymotion-F2)
nmap t <Plug>(easymotion-tl)
nmap T <Plug>(easymotion-Tl)
nmap <Leader><Leader>t <Plug>(easymotion-t2)
nmap <Leader><Leader>T <Plug>(easymotion-T2)

" navigation
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

nnoremap <Leader>nv :vnew<CR>
nnoremap <Leader>nh :new<CR>

" file tree
noremap <F5> <ESC>:NERDTreeToggle<CR>
noremap <F4> <ESC>:NERDTree<CR>
noremap <Leader>rc :NERDTreeFocus<cr>R<c-w><c-p>
noremap <Leader>rr :NERDTreeFocus<cr>Ro

nnoremap <Leader>h :History<CR>
nnoremap <Leader>o :Files<CR>

" ripgrep search
nnoremap <Leader>ff :Rg 
nnoremap <Leader>fw :Rg <C-r><C-w><CR>

" copy/paste to system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>y "+y

" vimrc
nnoremap <Leader>rv :source $MYVIMRC<CR>
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>

" file manipulations
nnoremap <Leader>D :call delete(expand('%'))<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :qa<CR>
nnoremap <Leader>w :w<CR>

" disable arrows
noremap <up> <nop>
inoremap <up> <nop>
noremap <down> <nop>
inoremap <down> <nop>
noremap <left> <nop>
inoremap <left> <nop>
noremap <right> <nop>
inoremap <right> <nop>

" remap join lines to gj and visual line navigation to J/K
nnoremap J gj
nnoremap K gk
nnoremap gj J
