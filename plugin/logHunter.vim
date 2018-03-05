" =============================================================================
" File:          plugin/logHunter.vim
" Description:   userful log collector.
" Author:        zechfox(zechfoxATgmail.com)
" =============================================================================
if ( exists('g:loaded_log_hunter') && g:loaded_log_hunter) || v:version < 700 || &cp
  finish
endif
let g:loaded_log_hunter= 1

let [g:log_hunter_sort_method, 
  \ g:log_hunter_sort_regex]
  \ = [[], []]

if !exists('g:log_hunter_map') | let g:log_hunter_map = '<c-p>' | endif
if !exists('g:log_hunter_add_entry') | let g:log_hunter_add_entry = 'addLg' | endif

" add new log entry to quickfix
" remove log entry from quickfix
" sort log by name, index, regex
" export log entry in the quickfix
" record search history of current bufferi, hint <CR> to apply search
"
