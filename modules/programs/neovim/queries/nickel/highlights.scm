;; extends

;; Patch syntax.
[
  "="
  "=>"
  "|"
] @operator

"." @punctuation.delimiter.accessor

(str_chunks_single) @string
(str_chunks_multi) @string
(multstr_start) @string
(multstr_end) @string
