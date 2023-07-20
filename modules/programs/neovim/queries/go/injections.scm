;; extends

;; Inject string placeholders into "" strings:
;;     "Hello, %s!"
;;             ^^
(interpreted_string_literal) @format_string

;; Inject string placeholders into `` strings:
;;     `Hello, %s!`
;;             ^^
(raw_string_literal) @format_string
