" See: http://vimdoc.sourceforge.net/htmldoc/options.html
" See: `:help option-list`

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Init.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set all options to their default value.
set all&
syntax off


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE(SuperPaintman): `*` checks a function.
if !exists('*s:reload_config')
  function! s:reload_config()
    source ~/.vimrc
    echom "Config reloaded!"
  endfunction
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! ReloadConfig call s:reload_config()
