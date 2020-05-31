# Vim

## Update plugins

```sh
$ rm -rf .vim/plugged
$ vim -c 'PlugClean! | PlugInstall | qa'
$ rm -rf .vim/plugged/**/.git
```

## coc.nvim

```vim
" C/C++.
:CocInstall coc-clangd
:CocCommand clangd.install
```
