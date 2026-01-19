;; extends

;; Highlight checked list item.
;;     - [x] Done
;;           ^^^^
;;     ^^^^^^^^^^
(list_item
  (task_list_marker_checked)
  .
  (_) @markup.list.checked.content)
