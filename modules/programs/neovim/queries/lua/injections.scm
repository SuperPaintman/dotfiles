;; Inject vim language into `cmd` expressions:
;;     cmd([[syntax on]])
;;     vim.cmd([[syntax on]])
(function_call
  name: [
         (dot_index_expression
           table: (identifier) @_table_id (#eq? @_table_id "vim")
           field: (identifier) @_id) 
         (identifier) @_id 
         ] (#eq? @_id "cmd")
  arguments: (arguments (string
                          content: (string_content) @vim)))
