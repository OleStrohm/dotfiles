"lua require('settings')
"lua require('plugins')
"lua require('plugin_settings')
"lua require('misc')

" Plugin dev {{{
" set conceallevel=2 concealcursor=nv
" call clearmatches()
" 
" function JumpPrompt()
" 	redraw
" 	nohlsearch
" 	echo ">"
" 	let l:cin = nr2char(getchar())
" 	let l:search = l:cin
" 	redraw
" 	echo ">" . l:search
" 	let l:cin = nr2char(getchar())
" 	let l:search = l:search . l:cin
" 	redraw
" 	echo ">" . l:search
" 	highlight JumpDeEmphasize ctermfg=darkgrey
" 	highlight Conceal ctermfg=red ctermbg=NONE
" 	let l:himatches = []
" 	call add(l:himatches, matchadd("JumpDeEmphasize", ".*", 1))
" 	call add(l:himatches, matchadd('Conceal', '\c' . l:search[0] . '\zs' . l:search[1], 3, -1, { 'conceal': '_' }))
" 	redraw
" 	let l:top = line('w0')
" 	let l:bot = line('w$')
" 	let l:matches = []
" 
" 	let l:i = l:top
" 	for l:i in range(l:top, l:bot)
" 		let l:line = getline(l:i)
" 
" 		let l:match = matchstrpos(l:line, '\c' . l:search)
" 		while l:match[1] >= 0
" 			call add(l:matches, [l:i, l:match[1] + 1])
" 			let l:match = matchstrpos(l:line, '\c' . l:search, l:match[2])
" 		endwhile
" 	endfor
" 
" 	let l:alphabet = "f;sd,oem"
" 	let l:jumpMap = {}
" 
" 	echo ceil(len(l:matches)/len(l:alphabet))
" 
" 	for l:i in range(0, len(l:matches)-1)
" 		let l:jumpMap[l:alphabet[l:i]] = l:matches[l:i]
" 		call add(l:himatches, matchadd('Conceal', '\%' . l:matches[l:i][0] . 'l\%' . l:matches[l:i][1] . 'c', 3, -1, { 'conceal': l:alphabet[l:i/ceil(len(l:matches)/len(l:alphabet))] }))
" 	endfor
" 	redraw!
" 
" 	let l:jumpchar = nr2char(getchar())
" 	if stridx(l:alphabet, l:jumpchar) >= 0
" 		let l:pos = getpos('.')
" 		let l:pos[1] = l:jumpMap[l:jumpchar][0]
" 		let l:pos[2] = l:jumpMap[l:jumpchar][1]
" 		call setpos('.', l:pos)
" 
" 		while len(l:himatches) > 0
" 			call matchdelete(l:himatches[0])
" 			call remove(l:himatches, 0)
" 		endwhile
" 	endif
" 	redraw
" 	echo ""
" 
" 	" Use matchaddpos (may be more efficient, maximum 8)
" 	" Would require a alphabet of length 8 and putting all similar
" 	" position into one match.
" 	" call matchaddpos('Conceal', [[5, 5]], 4, -1, { 'conceal': 'f' })
" endfunction
" }}}
