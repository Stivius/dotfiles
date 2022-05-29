local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('common')
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use 'preservim/nerdtree'
	use 'vim-airline/vim-airline'
	use '907th/vim-auto-save'
	use 'tpope/vim-surround'
	use 'easymotion/vim-easymotion'
	use 'tiagofumo/vim-nerdtree-syntax-highlight'
	use 'ryanoasis/vim-devicons'
	use 'fladson/vim-kitty'
	use 'chriskempson/base16-vim'
	use 'troydm/zoomwintab.vim'
 	use 'tpope/vim-unimpaired'

	-- Programming
	use { 'neoclide/coc.nvim', branch = 'release' }

	use 'chrisbra/NrrwRgn'
	use 'ledger/vim-ledger'
	use 'tpope/vim-commentary'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	-- use 'pangloss/vim-javascript'
	-- use 'leafgarland/typescript-vim'
	-- use 'HerringtonDarkholme/yats.vim'

	--Zettelkasten
	use({
		"iamcco/markdown-preview.nvim",
		run = function() vim.fn["mkdp#util#install"]() end,
	})

	-- Telescope
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-telescope/telescope-fzy-native.nvim'
	use 'fannheyward/telescope-coc.nvim'
end)

vim.cmd('filetype plugin on')

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = "all",

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },
}

-- change <Leader> key
nnoremap('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('coc')

-- autocommand (not yet supported in lua API)
vim.cmd([[
	" open help vertically
	augroup vimrc_help
		autocmd!
		autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
	augroup END
]])

-- unicode characters in the file autoload/float.vim
set_option('encoding', 'utf-8')
-- TextEdit might fail if hidden is not set.
set_option('hidden', true)
-- Some servers have issues with backup files, see #649.
set_option('backup', false)
set_option('writebackup', false)
-- Give more space for displaying messages.
set_option('cmdheight', 2)
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set_option('updatetime', 300)
-- Column for diagnostic messages
set_win_option('signcolumn', 'auto')

-- powerline
vim.g.airline_powerline_fonts = 1 -- use powerline fonts
vim.g.Powerline_symbols = 'unicode' -- support unicode

-- colorscheme
vim.cmd('colorscheme base16-tomorrow-night')
set_option('termguicolors', true)

-- fixes for highlight
vim.cmd([[
	hi! link typescriptTSKeywordOperator Keyword
	hi! link typescriptTSRepeat Keyword
	hi! link typescriptTSException Keyword
	hi! link CocSemClass Type
]])

-- enable russian layout
inoremap('<C-f>', '<C-^>')
nnoremap('<C-f>', 'a<C-^><ESC>')
set_option('keymap', 'russian-jcukenwin')
set_option('iminsert', 0) -- english by default
set_option('imsearch', 0) -- english by default

set_option('wrap', true) -- wrap words
set_option('linebreak', true) -- wrap words
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
set_option('encoding', 'UTF-8')
set_option('autoindent', true)
set_option('splitright', true) -- for vnew to work to the right
set_win_option('relativenumber', true)
set_win_option('number', true)

-- completion
inoremap('<CR>', 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>"', { expr = true })
inoremap('<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
inoremap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true })
inoremap('<C-Space>', 'coc#refresh()', { expr = true, silent = true })

-- search
noremap('<F9>', ':nohl<CR>')
noremap('<F8>', ':set ignorecase! ignorecase?<CR>')

-- map <Leader> <Plug>(easymotion-prefix)
nmap('f', '<Plug>(easymotion-fl)')
nmap('F', '<Plug>(easymotion-Fl)')
nmap('<Leader><Leader>f', '<Plug>(easymotion-f2)')
nmap('<Leader><Leader>F', '<Plug>(easymotion-F2)')
nmap('t', '<Plug>(easymotion-tl)')
nmap('T', '<Plug>(easymotion-Tl)')
nmap('<Leader><Leader>t', '<Plug>(easymotion-t2)')
nmap('<Leader><Leader>T', '<Plug>(easymotion-T2)')

-- coc
imap('<C-l>', '<Plug>(coc-snippets-expand)')
vmap('<C-j>', '<Plug>(coc-snippets-select)')

-- navigation
noremap('<C-k>', '<C-w>k')
noremap('<C-j>', '<C-w>j')
noremap('<C-h>', '<C-w>h')
noremap('<C-l>', '<C-w>l')

-- splits
nnoremap('<Leader>snv', ':vnew<CR>')
nnoremap('<Leader>snh', ':new<CR>')
nnoremap('<Leader>sv', '<C-w>v')
nnoremap('<Leader>sh', '<C-w>s')
nnoremap('<Leader>se', '<C-w>=')
nnoremap('<Leader>sf', ':ZoomWinTabToggle<CR>')
nnoremap('<C-Left>', ':vertical resize -3<CR>', { silent = true })
nnoremap('<C-Right>', ':vertical resize +3<CR>', { silent = true })
nnoremap('<C-Up>', ':resize +3<CR>', { silent = true })
nnoremap('<C-Down>', ':resize -3<CR>', { silent = true })

-- file tree
-- noremap <F4> <ESC>:NERDTree<CR>
noremap('<F5>', '<ESC>:NERDTreeToggle<CR>')
nnoremap('<Leader>rc', ':NERDTreeFocus<cr>R<c-w><c-p>')
nnoremap('<Leader>rr', ':NERDTreeFocus<cr>Ro')

-- nnoremap <Leader>qc  <cmd>cclose<cr>
-- nnoremap <Leader>qo  <cmd>copen<cr>

nnoremap('<Leader>h', '<cmd>Telescope oldfiles<cr>')
nnoremap('<Leader>o', '<cmd>Telescope find_files<cr>')
nnoremap('<Leader>ff', '<cmd>Telescope <cr>')
nnoremap('<Leader>fg', '<cmd>Telescope live_grep<cr>')
nnoremap('<Leader>fb', '<cmd>Telescope buffers<cr>')
nnoremap('<Leader>fh', '<cmd>Telescope help_tags<cr>')
nnoremap('<Leader>fw', '<cmd>Telescope grep_string<cr>')

-- copy/paste to system clipboard
noremap('<Leader>p', '"+p')
noremap('<Leader>y', '"+y')

-- vimrc
nnoremap('<Leader>rv', ':source $MYVIMRC<CR>')
nnoremap('<Leader>ev', ':vsplit $MYVIMRC<CR>')
nnoremap('<Leader>ee', ':e $MYVIMRC<CR>')

-- file manipulations
nnoremap('<Leader>D', ":call delete(expand('%'))<CR>")
nnoremap('<Leader>q', ':q<CR>')
nnoremap('<Leader>Q', ':qa<CR>')
nnoremap('<Leader>w', ':w<CR>')

-- disable arrows
noremap('<up>', '<nop>')
inoremap('<up>', '<nop>')
noremap('<down>', '<nop>')
inoremap('<down>', '<nop>')
noremap('<left>', '<nop>')
inoremap('<left>', '<nop>')
noremap('<right>', '<nop>')
inoremap('<right>', '<nop>')

-- remap join lines to gj and visual line navigation to J/K
nnoremap('J', 'gj')
nnoremap('K', 'gk')
nnoremap('gj', 'J')
