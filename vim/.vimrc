" See: http://vimdoc.sourceforge.net/htmldoc/options.html
" See: https://learnvimscriptthehardway.stevelosh.com/
" See: `:help option-list`

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reset.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set all options to their default value.
set all&


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE(SuperPaintman): `*` checks a function.
if !exists('*s:reload_config')
  function s:reload_config()
    source $MYVIMRC " Or `~/.vimrc`.
    echom "Config reloaded!"
  endfunction
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! ReloadConfig call s:reload_config()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Space> as a <Leader>. Double quotes are required.
let mapleader = "\<Space>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reload vim config.
" nnoremap <Leader>vr :ReloadConfig<CR>
