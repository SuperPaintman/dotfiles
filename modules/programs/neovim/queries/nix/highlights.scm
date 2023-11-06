;; extends

;; Patch syntax.
[
  "="
  ":"
] @operator

(ellipses) @operator

"." @punctuation.delimiter.accessor

;; Highlight function calls.
;;     a = lib.map x [];
;;             ^^^
(apply_expression
  function: (select_expression
              attrpath: (attrpath
                          attr: (_) @function.call ; Last attr.
                          .)))
