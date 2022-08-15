(fn command! [name ...]
  (var opts {})
  (var f nil)
  (var consume nil)

  (fn finalize [tbl n last]
    (assert-compile (= n (length tbl)) "unknown extra arguments")
    (set f last))

  (fn create-consumer [name ?checker]
    (let [checker (or ?checker #(values true false))]
      (fn [tbl n]
        (let [(v move) (checker (. tbl n))]
          (tset opts name v)
          (consume tbl (+ n (if move 1 0)))))))

  ;; See: https://neovim.io/doc/user/map.html#command-attributes
  (local consume-range
         (create-consumer :range
                          #(match $1
                             "%" (values "%" true)
                             _ (values true false))))
  (local consume-bang (create-consumer :bang))
  (local consume-bar (create-consumer :bar))
  (set consume (fn [tbl n]
                 (match (. tbl n)
                   :range (consume-range tbl (+ n 1))
                   :bang (consume-bang tbl (+ n 1))
                   :bar (consume-bar tbl (+ n 1))
                   last (finalize tbl n last))))
  (consume [...] 1)
  (assert-compile (not= f nil) "command cannot be nil")
  `(vim.api.nvim_create_user_command ,name ,f ,opts))

{: command!}
