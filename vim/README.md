# Vim

## Update plugins

```sh
$ rm -rf .vim/plugged
$ vim -c 'PlugClean! | PlugInstall | qa'
$ rm -rf .vim/plugged/**/.git
```
