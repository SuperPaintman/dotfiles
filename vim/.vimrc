" See: http://vimdoc.sourceforge.net/htmldoc/options.html
" See: https://learnvimscriptthehardway.stevelosh.com/
" See: `:help option-list`

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reset.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify the character encoding used in the script.
scriptencoding utf-8

" Set all options to their default value.
set all&

" Reset color scheme.
colorscheme default


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on

filetype plugin indent on

" Read file when changed outside of Vim.
set autoread

" Encoding used internally.
set encoding=utf-8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vim/colors/monokai/monokai.vim"))
  colorscheme monokai/monokai
endif


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
" Autocommands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check if an buffer was changed outside of Vim.
augroup checktime_on_cursor_hold
  autocmd!
  autocmd CursorHold * :checktime
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Space> as a <Leader>. Double quotes are required.
let mapleader = "\<Space>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Normal mode.
"" Reload vim config.
" nnoremap <Leader>vr :ReloadConfig<CR>

" Insert mode.
"" Escape.
inoremap jk <Esc>
