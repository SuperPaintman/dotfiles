;; extends

;; Patch syntax.
[
  "="
  "=>"
] @operator

"." @punctuation.delimiter.accessor

;; Highlight function calls.
;;     myFunction(true);
;;     ^^^^^^^^^^
(SuffixExpr
  variable_type_function: (IDENTIFIER) @function.call
  (FnCallArguments))

