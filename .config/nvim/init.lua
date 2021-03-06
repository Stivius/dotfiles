local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

require('common')
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- ui
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'chriskempson/base16-vim'
  use 'ryanoasis/vim-devicons'
  use 'lukas-reineke/indent-blankline.nvim'

  -- editing
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'windwp/nvim-autopairs'

  -- navigation
  use 'mhinz/vim-startify'
  use 'troydm/zoomwintab.vim'
  use 'tpope/vim-unimpaired' -- learn
  use 'ggandor/lightspeed.nvim'
  use 'qpkorr/vim-bufkill'
  use 'preservim/nerdtree'
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  use 'liuchengxu/vim-which-key'

  -- File-specific
  use 'ledger/vim-ledger'
  use 'fladson/vim-kitty'
  use 'cdelledonne/vim-cmake' -- setup

  -- Programming
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'numToStr/Comment.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'tpope/vim-fugitive' -- learn, setup
  use 'airblade/vim-gitgutter' -- learn, setup
  use 'vim-test/vim-test'
  use 'kana/vim-textobj-user'
  use 'julian/vim-textobj-variable-segment'

  --Zettelkasten
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'preservim/vim-markdown'

  -- Telescope, setup
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'fannheyward/telescope-coc.nvim'
end)

vim.cmd('filetype plugin on')

require('Comment').setup()

vim.g.NERDTreeChDirMode = 2
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeIgnore = { 'node_modules', '.git', '^build' }

vim.g.startify_change_cmd = 'cd'
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_lists = {
  { type = 'sessions', header = { '   Sessions' } },
  { type = 'bookmarks', header = { '   Bookmarks' } },
  { type = 'commands', header = { '   Commands' } },
  { type = 'files', header = { '   MRU' } },
  { type = 'dir', header = { '   MRU ' .. vim.fn.getcwd() } },
}
vim.g.startify_bookmarks = {
  '~/.todo/todo.txt',
  '~/.productivity/productivity.txt',
  '~/.finances/transactions.ledger',
  '~/.finances/parsed.ledger',
}

require('telescope').setup {
  defaults = {
    mappings = {
      n = {
        ['<C-d>'] = require('telescope.actions').delete_buffer
      }, -- normal mode
      i = {
        ['<C-h>'] = 'which_key',
        ['<C-d>'] = require('telescope.actions').delete_buffer
      } -- insert mode
    }
  },
  pickers = {
    find_files = {
      theme = 'dropdown',
      previewer = false
    },
    buffers = {
      theme = 'dropdown',
      previewer = false
    },
    jumplist = {
      theme = 'dropdown',
    }
  },
  extensions = {
    coc = {
      theme = 'dropdown'
    }
  }
}
require('telescope').load_extension('coc')

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
vim.opt.listchars:append("space:???")

require('lualine').setup {
  sections = {
    lualine_x = { 'filetype' },
    lualine_c = {
      {
        'filename',
        file_status = true,
      }
    }
  }
}

require("indent_blankline").setup {}
require('nvim-autopairs').setup {}

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = "all",

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  highlight = {
    enable = true,

    disable = { 'markdown' }

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },
}

vim.opt.foldlevelstart = 99
vim.g.vim_markdown_frontmatter = 1

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
vim.opt.keymap = 'russian-jcukenwin';
vim.opt.iminsert = 0;  -- english by default
vim.opt.imsearch = 0;  -- english by default

vim.opt.wrap = true;  -- wrap words
vim.opt.linebreak = true;  -- wrap words
vim.opt.tabstop = 4;
vim.opt.shiftwidth = 2;
vim.opt.autoindent = true;
vim.opt.splitright = true;  -- for vnew to work to the right
vim.opt.relativenumber = true;
vim.opt.number = true;

-- completion
inoremap('<CR>', 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>"', { expr = true })
inoremap('<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
inoremap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true })
inoremap('<C-Space>', 'coc#refresh()', { expr = true, silent = true })

-- search
noremap('<F9>', ':nohl<CR>')
noremap('<F8>', ':set ignorecase! ignorecase?<CR>')

-- coc
imap('<C-l>', '<Plug>(coc-snippets-expand)')
vmap('<C-j>', '<Plug>(coc-snippets-select)')

-- navigation
noremap('<C-k>', '<C-w>k')
noremap('<C-j>', '<C-w>j')
noremap('<C-h>', '<C-w>h')
noremap('<C-l>', '<C-w>l')

-- which_key
nnoremap('<Leader>', ":WhichKey '<Space>' <CR>")
nnoremap(']', ":WhichKey ']' <CR>")
nnoremap('[', ":WhichKey '[' <CR>")
nnoremap('g', ":WhichKey 'g' <CR>")

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
noremap('<F5>', '<ESC>:NERDTreeToggle<CR>')
nnoremap('<Leader>rc', ':NERDTreeFocus<cr>R<c-w><c-p>')
nnoremap('<Leader>rr', ':NERDTreeFocus<cr>Ro')

nnoremap('<Leader>o', '<cmd>Telescope find_files<cr>')
nnoremap('<Leader>ff', '<cmd>Telescope <cr>')
nnoremap('<Leader>fq', '<cmd>Telescope quickfix<cr>')
nnoremap('<Leader>fj', '<cmd>Telescope jumplist<cr>')
-- FIXME add to quickfix
nnoremap('<Leader>fm', '<cmd>lua require("telescope.builtin").grep_string({ search = "FIXME" })<cr>')
nnoremap('<Leader>fg', '<cmd>Telescope live_grep<cr>')
nnoremap('<Leader>fb', '<cmd>Telescope buffers<cr>')
nnoremap('<Leader>fh', '<cmd>Telescope help_tags<cr>')
nnoremap('<Leader>fw', '<cmd>Telescope grep_string<cr>')
nnoremap('<Leader>fvb', '<cmd>Telescope git_branches<cr>')
nnoremap('<Leader>fvs', '<cmd>Telescope git_stash<cr>')

nnoremap('<Leader>tt', '<cmd>TestSuite<cr>')
nnoremap('<Leader>tc', '<cmd>TestNearest<cr>')
nnoremap('<Leader>tl', '<cmd>TestLast<cr>')
tmap('<C-o>', '<C-\\><C-n>')

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

-- merge
nmap_local('<Leader>mc', ':Gvdiffsplit!<CR>')
nmap_local('<Leader>mf', ':only<CR>')
nmap_local('gdh', ':diffget //2<CR>')
nmap_local('gdl', ':diffget //3<CR>')
