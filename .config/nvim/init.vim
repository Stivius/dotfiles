let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-surround'
  Plug '907th/vim-auto-save'
  Plug 'tpope/vim-surround'
  Plug 'easymotion/vim-easymotion'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'ryanoasis/vim-devicons'
  Plug 'fladson/vim-kitty'
  Plug 'chriskempson/base16-vim'
  Plug 'troydm/zoomwintab.vim'
  Plug 'tpope/vim-unimpaired'
  " Telescope
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'fannheyward/telescope-coc.nvim'
call plug#end()

filetype plugin on

let g:airline_powerline_fonts = 1 " use powerline fonts
let g:Powerline_symbols='unicode' " support unicode

colorscheme base16-classic-dark
set termguicolors

" enable russian layout
set keymap=russian-jcukenwin  
set iminsert=0 " default - enlgish
set imsearch=0 " default - english
inoremap <C-Space> <C-^>
nnoremap <C-Space> a<C-^><ESC>

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

" coc
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)

" navigation
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" splits
nnoremap <Leader>snv :vnew<CR>
nnoremap <Leader>snh :new<CR>
nnoremap <Leader>sv <C-w>v
nnoremap <Leader>sh <C-w>s
nnoremap <Leader>se <C-w>=
nnoremap <Leader>sf :ZoomWinTabToggle<CR>
nnoremap <silent> <C-Left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>

" file tree
noremap <F5> <ESC>:NERDTreeToggle<CR>
"noremap <F4> <ESC>:NERDTree<CR>
nnoremap <Leader>rc :NERDTreeFocus<cr>R<c-w><c-p>
nnoremap <Leader>rr :NERDTreeFocus<cr>Ro

nnoremap <Leader>qc  <cmd>cclose<cr>
nnoremap <Leader>qo  <cmd>copen<cr>

nnoremap <Leader>h  <cmd>Telescope oldfiles<cr>
nnoremap <Leader>o  <cmd>Telescope find_files<cr>
nnoremap <Leader>ff <cmd>Telescope <cr>
nnoremap <Leader>fg <cmd>Telescope live_grep<cr>
nnoremap <Leader>fb <cmd>Telescope buffers<cr>
nnoremap <Leader>fh <cmd>Telescope help_tags<cr>
nnoremap <Leader>fw <cmd>Telescope grep_string<cr>

" copy/paste to system clipboard
noremap <Leader>p "+p
noremap <Leader>y "+y

" vimrc
nnoremap <Leader>rv :source $MYVIMRC<CR>
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>ee :e $MYVIMRC<CR>

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
