" =============================================================================
" File:          plugin/logHunter.vim
" Description:   userful log collector.
" Author:        zechfox(zechfoxATgmail.com)
" =============================================================================
if ( exists('g:loaded_log_hunter') && g:loaded_log_hunter) || v:version < 700 || &cp
"  finish
endif
let g:loaded_log_hunter = 1


command! -nargs=* AddEntry    :call logHunter#AddEntry(<f-args>)

