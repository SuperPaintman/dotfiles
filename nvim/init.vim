""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Init the default Vim config.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if isdirectory(expand("~/.vim"))
  " Use ~/.vim as the runtime path.
  set runtimepath^=~/.vim,~/.vim/after
endif

if filereadable(expand("~/.vimrc"))
  source ~/.vimrc
endif
