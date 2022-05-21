-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap_local('[g', '<Plug>(coc-diagnostic-next)')
nmap_local(']g', '<Plug>(coc-diagnostic-prev)')

-- GoTo code navigation.
nmap_local('gd', '<Plug>(coc-definition)')
nmap_local('gy', '<Plug>(coc-type-definition)')
nmap_local('gi', '<Plug>(coc-implementation)')
nmap_local('gr', '<Plug>(coc-references)')

-- Symbol renaming.
nmap_local('<Leader>rn', '<Plug>(coc-rename)')

-- Formatting selected code.
nmap_local('<Leader>f', '<Plug>(coc-format-selected)')
xmap_local('<Leader>f', '<Plug>(coc-format-selected)')

-- Applying codeAction to the selected region.
-- Example: `<leader>cap` for current paragraph
nmap_local('<Leader>ca', '<Plug>(coc-codeaction-selected)')
xmap_local('<Leader>ca', '<Plug>(coc-codeaction-selected)')

-- Remap keys for applying codeAction to the current buffer.
nmap_local('<Leader>caa', '<Plug>(coc-codeaction)')
-- Apply AutoFix to problem on the current line.
nmap_local('<Leader>fc', '<Plug>(coc-fix-current)')
-- Run the Code Lens action on the current line.
nmap_local('<Leader>cal', '<Plug>(coc-codelens-action)')

-- Convert selection to snippet
xmap_local('<leader>snp', '<Plug>(coc-convert-snippet)')

-- Mappings for CoCList
-- Show all diagnostics.
nnoremap_local('<Leader>ld', ':<C-u>CocList diagnostics<cr>', { silent = true, nowait = true })
-- Manage extensions.
nnoremap_local('<Leader>le', ':<C-u>CocList extensions<cr>', { silent = true, nowait = true })
-- Show commands.
nnoremap_local('<Leader>lc', ':<C-u>CocList commands<cr>', { silent = true, nowait = true })
-- Find symbol of current document.
nnoremap_local('<Leader>lo', ':<C-u>CocList outline<cr>', { silent = true, nowait = true })
-- Search workspace symbols.
nnoremap_local('<Leader>ls', ':<C-u>CocList -I symbols<cr>', { silent = true, nowait = true })
-- Do default action for next/prev item.
-- nnoremap_local('<Leader>j', ':<C-u>CocNext<CR>', { silent = true, nowait = true})
-- nnoremap_local('<Leader>k', ':<C-u>CocPrev<CR>', { silent = true, nowait = true})

function show_documentation()
   if vim.fn.CocAction('hasProvider', 'hover') then
	   vim.fn.CocActionAsync('doHover')
   end
end

-- Use K to show documentation in preview window.
nnoremap_local('gh', ':lua show_documentation()<CR>', { silent = true })

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap_local('if', '<Plug>(coc-funcobj-i)')
omap_local('if', '<Plug>(coc-funcobj-i)')
xmap_local('af', '<Plug>(coc-funcobj-a)')
omap_local('af', '<Plug>(coc-funcobj-a)')
xmap_local('ic', '<Plug>(coc-classobj-i)')
omap_local('ic', '<Plug>(coc-classobj-i)')
xmap_local('ac', '<Plug>(coc-classobj-a)')
omap_local('ac', '<Plug>(coc-classobj-a)')

-- Remap <C-f> and <C-b> for scroll float windows/popups.
  nnoremap_local('<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', { nowait = true, expr = true, silent = true })
  nnoremap_local('<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', { nowait = true, expr = true, silent = true })
  inoremap_local('<C-f>', 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(1)\\<cr>" : "\\<Right>"', { nowait = true, expr = true, silent = true })
  inoremap_local('<C-b>', 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(0)\\<cr>" : "\\<Left>"', { nowait = true, expr = true, silent = true })
  vnoremap_local('<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', { nowait = true, expr = true, silent = true })
  vnoremap_local('<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', { nowait = true, expr = true, silent = true })

-- Requires 'textDocument/selectionRange' support of language server.
nmap_local('<C-s>', '<Plug>(coc-range-select)')
xmap_local('<C-s>', '<Plug>(coc-range-select)')

-- Add `:Format` command to format current buffer.
create_user_command(
	'Format',
	function ()
		vim.fn.CocActionAsync('format')
	end,
	{ nargs = 0, buffer = true }
)
-- Add `:OR` command for organize imports of the current buffer.
create_user_command(
	'OR',
	function ()
		vim.fn.CocActionAsync('runCommand', 'editor.action.organizeImport')
	end,
	{ nargs = 0, buffer = true }
)

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append({ c = true })
