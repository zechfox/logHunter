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
    let new_items = [{'bufnr': a:bufnr, 'lnum': a:lnum, 'text': a:text}]
    let is_ok = setqflist([], 'a', {'id':g:log_hunter_qflist_id, 'items': new_items})
    if is_ok == 0
	echo logHunter#GetQflist()
    else
	echom "add new entry for logHunter failed!"
    endif
endfunction

function! logHunter#GetQflist()
    if has_key(getqflist({'id' : g:log_hunter_qflist_id}), 'id')
	return getqflist({'id':g:log_hunter_qflist_id, 'items':0})
    else
	" if no logHunter quickfix list, just create it
	let ret_val = setqflist([], ' ', {'title':'logHunter'})
	if ret_val
	    g:log_hunter_qflist_id = getqflist({'id' : 0}).id
	    return getqflist({'id':g:log_hunter_qflist_id, 'items':0})
	else
	    echom "create quickfix for logHunter failed!"
	    return []
endfunction
