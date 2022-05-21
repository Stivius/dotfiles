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

-- Use K to show documentation in preview window.
nnoremap_local('K', ':call show_documentation()<CR>', { silent = true })


vim.cmd([[
function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
]])

--[[
-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)


" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
--]]
