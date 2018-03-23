" =============================================================================
" File:          plugin/logHunter.vim
" Description:   userful log collector.
" Author:        zechfox(zechfoxATgmail.com)
" =============================================================================
if ( exists('g:loaded_log_hunter') && g:loaded_log_hunter) || v:version < 700 || &cp
"  finish
endif
let g:loaded_log_hunter= 1

let [g:log_hunter_sort_method, 
  \ g:log_hunter_sort_regex,
  \ g:log_hunter_qflist_id]
  \ = [[], [], -1]

if !exists('g:log_hunter_map') | let g:log_hunter_map = '<c-p>' | endif
if !exists('g:log_hunter_add_entry') | let g:log_hunter_add_entry = 'addLg' | endif

" add new log entry to quickfix
" remove log entry from quickfix
" sort log by name, index, regex
" export log entry in the quickfix
" record search history of current bufferi, hint <CR> to apply search
"
function! logHunter#AddEntry(bufnr, lnum, text, ...)
    " try print out parameters
    let l:qflist = logHunter#GetQflist()
    let l:new_items = [{'bufnr': a:bufnr, 'lnum': a:lnum, 'text': a:text}]
    let l:item_index = index(l:qflist, l:new_item)
    if l:item_index >= 0
	echom "entry already exist!"
	return

    let l:is_ok = setqflist([], 'a', {'id':g:log_hunter_qflist_id, 'items': l:new_items})
    if 0 == l:is_ok
	echo logHunter#GetQflist()
    else
	echom "add new entry for logHunter failed!"
    endif
endfunction

function! <SID>CompareBufNum(item1, item2)
    if (a:item1).bufnr == (a:item2).bufnr
    return (a:item1).lnum == (a:item2).lnum ? 0 : ( (a:item1).lnum < (a:item2).lnum ? -1 : 1)
  elseif (a:item1).bufnr < (a:item2).bufnr
    return -1
  else
    return 1
  endif
endfunction

function! logHunter#SortEntries(sort_type, ...)
    let l:qflist = logHunter#GetQflist()
    let l:sortedList = sort(l:qflist, "<SID>CompareBufNum")
    if 'bufnr' == a:sort_type
	echo 'sort list by buffer number'

    elseif 'regexp' == a:sort_type
	echo 'sort list by regexp'
	let l:regexp = a:1

    else
	echo 'not support this sort type'

    endif

endfunction

function! logHunter#DeleteEntry(bufnr, lnum, text, ...)
    let l:qflist = logHunter#GetQflist()
    let l:item = [{'bufnr': a:bufnr, 'lnum': a:lnum, 'text': a:text}]
    " call filter(l:qflist, 'v:val !=# l:item')
    let l:item_index = index(l:qflist, l:item)
    if -1 == l:item_index
	echom "delete entry failed: no entry found!"
    else
        call remove(l:qflist, l:item_index)
endfunction

function! logHunter#InitialQflist()
    " if no logHunter quickfix list, just create it
    if -1 == g:log_hunter_qflist_id
	let l:ret_val = setqflist([], ' ', {'title':'logHunter'})
	if 0 == l:ret_val
	    g:log_hunter_qflist_id = getqflist({'id' : 0}).id
	    return 0
	else
	    echom "create quickfix for logHunter failed!"
	    return -1
	endif
    endif
    " logHunter quickfix list exists
    return 0
endfunction

function! logHunter#GetQflist()
    if has_key(getqflist({'id' : g:log_hunter_qflist_id}), 'id')
	return getqflist({'id':g:log_hunter_qflist_id, 'items':0})
    else
	" if no logHunter quickfix list, just create it
	let l:initial_ok = logHunter#InitialQflist()
	if 0 == l:initial_ok
	    return getqflist({'id':g:log_hunter_qflist_id, 'items':0})
	else
	    return []
	endif
    endif
endfunction
