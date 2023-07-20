;; extends

;; Inject vim language into `cmd` expressions:
;;     cmd([[syntax on]])
;;           ^^^^^^^^^
(function_call
  name: (identifier) @_id (#eq? @_id "cmd")
  arguments: (arguments (string
                          content: (string_content) @vim)))
