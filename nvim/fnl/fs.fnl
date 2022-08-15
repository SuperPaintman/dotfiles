;; See: https://vimhelp.org/builtin.txt.html

(local {: number->bool} (require :utils))

;; Wrappers.
(fn expand [s ?nosuf ?list]
  (_G.vim.fn.expand s ?nosuf ?list))

(fn directory? [directory]
  (number->bool (_G.vim.fn.isdirectory directory)))

(fn file-readable? [file]
  (number->bool (_G.vim.fn.filereadable file)))

{: expand : directory? : file-readable?}
