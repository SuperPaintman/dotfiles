;; extends

;; Patch syntax.
[
  "->"
  "=>"
] @operator

; (match_arm
;   pattern: (_)
;   .
;   "=>" @operator)

[
  "."
  "::"
] @punctuation.delimiter.accessor

(const_item "const" @keyword) 

(extern_modifier "extern" @keyword)

(macro_definition
  "macro_rules!" @keyword)

(metavariable) @keyword
