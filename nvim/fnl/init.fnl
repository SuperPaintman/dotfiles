;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Init the default Vim config.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import-macros {: command!} :vim)

(local fennel (require :fennel))
(local {: map : member?} (require :fennel.utils))
(local {: expand : directory? : file-readable?} (require :fs))

(local {: cmd : opt : api : bo} vim)

(when (directory? (expand "~/.vim"))
  (opt.runtimepath:prepend (map ["~/.vim" "~/.vim/after"] expand)))

(when (file-readable? (expand "~/.vimrc"))
  (cmd (.. "source " (expand "~/.vimrc"))))

(command! :Eval :range "%"
          (fn [opts]
            (let [filetype bo.filetype
                  {: line1 : line2} opts]
              (if (member? filetype [:lua :fennel :vim])
                  (let [lines (api.nvim_buf_get_lines 0 (- line1 1) line2 false)
                        source (table.concat lines "\n")]
                    (match filetype
                      :lua (let [f (loadstring source)]
                             (f))
                      :fennel (fennel.eval source)
                      :vim (api.nvim_exec source false)))))))
