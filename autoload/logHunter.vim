" =============================================================================
" File:          autoload/logHunter.vim
" Description:   userful log collector.
" Author:        zechfox(zechfoxATgmail.com)
" =============================================================================
if ( exists('g:loaded_log_hunter_auto') && g:loaded_log_hunter_auto) || v:version < 700 || &cp
"  finish
endif
let g:loaded_log_hunter_auto = 1

let [g:log_hunter_sort_method, 
  \ g:log_hunter_sort_regex,
  \ g:log_hunter_qflist_id]
  \ = [[], '^\[\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3}\s', -1]

if !exists('g:log_hunter_map') | let g:log_hunter_map = '<c-p>' | endif
if !exists('g:log_hunter_add_entry') | let g:log_hunter_add_entry = 'addLg' | endif

function! logHunter#AddEntry(...)
    if a:0 == 0
	let l:lnum = line(".")
	let l:bufnr = bufnr('%')
	let l:text = getline(".")
    else
	let l:bufnr = a:1
	let l:lnum = a:2
	let l:text = a:3
    endif
    let l:qflist = logHunter#GetQflist()
    let l:match_reg = matchstr(l:text, g:log_hunter_sort_regex)
    let l:new_item = [{'bufnr': l:bufnr, 'lnum': l:lnum, 'text': l:text, 'match_reg':match_reg}]
    " check duplicated item
    if !empty(l:qflist)
	let l:item_index = index(l:qflist, l:new_item)
	if l:item_index >= 0
	    echom "entry already exist!"
	    return
	endif
    endif
    let l:is_ok = setqflist([], 'a', {'id':g:log_hunter_qflist_id, 'items': l:new_item})
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

function! <SID>CompareRegExp(item1, item2)
    if (a:item1).match_reg > (a:item2).match_reg
	return 1
    else
	return -1
endfunction

function! logHunter#SortEntries(sort_type, ...)
    let l:qflist = logHunter#GetQflist()
    let l:sortedList = []
    if 'bufnr' == a:sort_type
	echo 'sort list by buffer number'
	let l:sortedList = sort(l:qflist, "<SID>CompareBufNum")
    elseif 'regexp' == a:sort_type
	echo 'sort list by regexp'
	let l:sortedList = sort(l:qflist, "<SID>CompareRegExp")
    else
	echo 'not support this sort type'
    endif
    call setqflist(l:sortedList)
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
	    let g:log_hunter_qflist_id = getqflist({'id':0}).id
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
    if 0 != getqflist({'id' : g:log_hunter_qflist_id}).id
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

" TODO:
" move items in quickfix windows
" export log entry in the quickfix
" record search history of current bufferi, hint <CR> to apply search
" display filename and line in status bar when broswer quickfix items

