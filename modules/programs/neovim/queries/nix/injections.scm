;; Inject lua language into `mkRawLua` expressions:
;;     mkRawLua ''local a = 1''
;;                ^^^^^^^^^^^
(apply_expression
  function: (variable_expression
              name: (identifier) @_name (#eq? @_name "mkRawLua"))
  argument: (indented_string_expression (string_fragment) @lua))
