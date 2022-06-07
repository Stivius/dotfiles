local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('common')
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use 'vim-airline/vim-airline' -- setup
	use '907th/vim-auto-save'
	use 'chriskempson/base16-vim'
	use 'troydm/zoomwintab.vim'

	-- editing
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'

	-- navigation
 	use 'tpope/vim-unimpaired' -- learn
	use 'easymotion/vim-easymotion' -- learn
	use 'preservim/nerdtree'
	use 'Xuyuanp/nerdtree-git-plugin'
	use 'tiagofumo/vim-nerdtree-syntax-highlight'

	-- File-specific
	use 'ledger/vim-ledger'
	use 'fladson/vim-kitty'
	use 'ryanoasis/vim-devicons'
	use 'cdelledonne/vim-cmake' -- setup

	-- Programming
	use 'lukas-reineke/indent-blankline.nvim' -- setup
	use 'windwp/nvim-autopairs'
	use { 'neoclide/coc.nvim', branch = 'release' }
	use 'tpope/vim-commentary'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use 'tpope/vim-fugitive' -- learn, setup
	use 'airblade/vim-gitgutter' -- learn, setup

	--Zettelkasten
	use({
		"iamcco/markdown-preview.nvim",
		run = function() vim.fn["mkdp#util#install"]() end,
	})

	-- Telescope, setup
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-telescope/telescope-fzy-native.nvim'
	use 'fannheyward/telescope-coc.nvim'
end)

vim.cmd('filetype plugin on')

vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeIgnore = { 'node_modules', '.git', 'build' }

vim.api.nvim_create_autocmd({"VimEnter"}, {
	pattern = "*",
	callback = function()
		if vim.fn.argc() == 0 then
			vim.api.nvim_command('NERDTree');
			vim.api.nvim_command('wincmd p');
		end
	end
})

-- FIXME not working with telescope
-- vim.api.nvim_create_autocmd({"BufEnter"}, {
-- 	pattern = "*",
-- 	callback = function()
-- 		local nerdName = 'NERD_tree_'
-- 		local current = vim.fn.bufname('%');
-- 		local alternate = vim.fn.bufname('#');
-- 		local lastWindowNumber = vim.fn.winnr('$');
-- 		if not string.match(current, nerdName) and string.match(alternate, nerdName) and lastWindowNumber > 1 then
-- 		end
-- 	end
-- })

-- colorscheme
vim.cmd('colorscheme base16-tomorrow-night')
vim.opt.termguicolors = true;

--FIXME rewrite in lua
vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#3c3c3c gui=nocombine]]
vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=#3c3c3c gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar guifg=#3c3c3c gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=#3c3c3c gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextStart guifg=#3c3c3c gui=nocombine]]
vim.cmd [[highlight! link NonText IndentBlanklineSpaceChar]]

vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup {}
require('nvim-autopairs').setup{}

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

-- FIXME rewrite to lua
vim.cmd([[
	" open help vertically
	augroup vimrc_help
		autocmd!
		autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
	augroup END
]])

vim.opt.hlsearch = false;
-- unicode characters in the file autoload/float.vim
vim.opt.encoding = 'utf-8';
-- TextEdit might fail if hidden is not set.
vim.opt.hidden = true;
-- Some servers have issues with backup files, see #649.
vim.opt.backup = false;
vim.opt.writebackup = false;
-- Give more space for displaying messages.
vim.opt.cmdheight = 2;
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
vim.opt.updatetime = 300;
-- Column for diagnostic messages
vim.opt.signcolumn = 'auto';
-- space instead of tabs
vim.opt.expandtab = true

-- powerline
vim.g.airline_powerline_fonts = 1 -- use powerline fonts
vim.g.Powerline_symbols = 'unicode' -- support unicode

-- fixes for highlight
function link_hl_group(linkedGroup, group)
	local groupByName = vim.api.nvim_get_hl_by_name(group, true);
	vim.api.nvim_set_hl(0, linkedGroup, groupByName);
end
link_hl_group('typescriptTSException', 'Keyword')
link_hl_group('typescriptTSKeywordOperator', 'Keyword')
link_hl_group('typescriptTSRepeat', 'Keyword')

-- enable russian layout
inoremap('<C-f>', '<C-^>')
nnoremap('<C-f>', 'a<C-^><ESC>')
<<<<<<< HEAD
set_option('keymap', 'russian-jcukenwin')
set_option('iminsert', 0) -- english by default
set_option('imsearch', 0) -- english by default

set_option('wrap', true) -- wrap words
set_option('linebreak', true) -- wrap words
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
set_option('encoding', 'UTF-8')
set_option('autoindent', true)
set_option('splitright', true) -- for vnew to work to the right
set_win_option('relativenumber', true)
set_win_option('number', true)
=======
vim.opt.keymap = 'russian-jcukenwin';
vim.opt.iminsert = 0; -- english by default
vim.opt.imsearch = 0; -- english by default

vim.opt.wrap = true; -- wrap words
vim.opt.linebreak = true; -- wrap words
vim.opt.tabstop = 4;
vim.opt.shiftwidth = 4;
vim.opt.autoindent = true;
vim.opt.splitright = true; -- for vnew to work to the right
vim.opt.relativenumber = true;
vim.opt.number = true;
>>>>>>> 0f1c95ccb2aea223f5ffba5d970634c5f1c99269

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

-- remap join lines to gj and visual line navigation to J/K
nnoremap('J', 'gj')
nnoremap('K', 'gk')
nnoremap('gj', 'J')
