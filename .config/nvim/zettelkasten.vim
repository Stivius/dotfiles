let b:markdown_folding = 1
setlocal nofoldenable

function! s:PrepareFilename(lines)
    let joined_lines = join(a:lines, "\n")
    if len(a:lines) > 1
	let joined_lines .= "\n"
    endif
    return joined_lines
endfunction

function! s:PasteFromFile(lines)
    let filename = s:PrepareFilename(a:lines)
    execute 'read ' .. filename | " doesn't work with | in files
    silent! %s/{{title}}/\=expand('%:t:r')/g
    silent! %s/{{date}}/\=strftime('%d-%m-%Y')/g
    silent! %s/{{today}}/\=strftime('%d-%m-%Y')/g
     "to remove new line
    normal! k"_dd
endfunction

function! s:SaveAndRemove(old_name, new_name)
    if a:new_name != '' && a:new_name != a:old_name
		exec ':saveas ' . escape(a:new_name, '#%|"')
		exec ':silent !rm ' . escape(a:old_name, ' ?#!()&%|"''')
		redraw!
		return v:true
    endif
	return v:false
endfunction

function! s:MoveFile(lines)
    let folder = s:PrepareFilename(a:lines)
    let old_name = expand('%')
    let new_name = folder . '/' . expand('%:t')
	let result = s:SaveAndRemove(old_name, new_name)
	if !result
		echomsg "Error while moving file"
	endif
endfunction

function! s:RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
	let result = s:SaveAndRemove(old_name, new_name)
	if !result
		echomsg "Error while renaming file"
	endif
endfunction

function! s:RenameFileAndTitle()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
	let result = s:SaveAndRemove(old_name, new_name)
	if result
		" change Space to Leader
		exec "normal \<ESC>gg\<Space>ti"
	endif
endfunction

function! s:OpenNoteInObsidian()
	exec "!xdg-open 'obsidian://open?vault=Zettelkasten&file=" . expand('%') . "'"
endfunction

function! s:OpenMetaNote()
	/Tags::
	normal y$
	let line = @"
	exec "!echo " . line . " | grep -oP '(?<=\\[\\[)[^\\[\\]]+' | rofi -dmenu | xargs -I {} xdg-open 'obsidian://open?vault=Zettelkasten&file={}'"
endfunction

function! s:GetTag()
	let result = system("grep -oP Tags::.+ Notes/*.md | grep -oP '(?<=\\[\\[)[^\\[\\]]+' | sort | uniq -d | rofi -dmenu")
	if result != ""
		let resultNoLine = substitute(result, '\n', '', '')
		call setreg('t', '[[' . resultNoLine . ']]')
	else
		call setreg('t', '')
	endif
endfunction

function! s:GetName()
	let result = system("ls Notes/*.md | sed 's/Notes\\///g' | sed 's/.md//g' | sort | rofi -dmenu")
	if result != ""
		let resultNoLine = substitute(result, '\n', '', '')
		call setreg('t', '[[' . resultNoLine . ']]')
	else
		call setreg('t', '')
	endif
endfunction

command! -bang Directories call fzf#run(fzf#wrap({'source': 'find . -type d -not -path "./.obsidian*"'})) " show only dirs without .obsidian

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-i': function('s:PasteFromFile'),
  \ 'ctrl-b': function('s:MoveFile')}

nnoremap <buffer> <C-p> <Plug>MarkdownPreviewToggle

inoremap <buffer> <C-t> <ESC>:call <SID>GetTag()<CR>a<C-r>t
inoremap <buffer> <C-k> <ESC>:call <SID>GetName()<CR>a<C-r>t

" open YouTube link (todo: probably sleep)
nnoremap <buffer> <Leader>yt /embed<CR>:nohl<CR>gx

" keybindings for Zettelkasten templates
nnoremap <buffer> <Leader>i :Files Templates/<CR>
nnoremap <buffer> <Leader>ti :call <SID>PasteFromFile(['Templates/Aux/H1 Title.md'])<CR>
nnoremap <buffer> <Leader>ph :call <SID>PasteFromFile(['Templates/Priority/High Priority.md'])<CR>
nnoremap <buffer> <Leader>pm :call <SID>PasteFromFile(['Templates/Priority/Medium Priority.md'])<CR>
nnoremap <buffer> <Leader>pl :call <SID>PasteFromFile(['Templates/Priority/Low Priority.md'])<CR>
nnoremap <buffer> <Leader>sp :call <SID>PasteFromFile(['Templates/Status/Pre-Processing Status.md'])<CR>
nnoremap <buffer> <Leader>sip :call <SID>PasteFromFile(['Templates/Status/In-Progress Status.md'])<CR>
nnoremap <buffer> <Leader>sr :call <SID>PasteFromFile(['Templates/Status/Research Status.md'])<CR>
nnoremap <buffer> <Leader>sd :call <SID>PasteFromFile(['Templates/Status/Done Status.md'])<CR>

nnoremap <buffer> <Leader>mn :call <SID>MoveFile(['Notes'])<CR>
nnoremap <buffer> <Leader>mm :Directories<CR>

nnoremap <buffer> <Leader>mo :call <SID>OpenMetaNote()<CR>
nnoremap <buffer> <Leader>no :call <SID>OpenNoteInObsidian()<CR>

" todo: use <F2> here as well
noremap <buffer> <F3> :call <SID>RenameFile()<CR>
noremap <buffer> <F2> :call <SID>RenameFileAndTitle()<CR>
