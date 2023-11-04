;; extends
(function_definition
  body: (body)? @function.inner) @function.outer

(constructor_definition
  body: (body)? @function.inner) @function.outer

((arguments
  (_) @parameter.inner
  . ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

(arguments
  . ["(" ","] @_start
  (_) @parameter.inner @parameter.outer
  . ")" @_end)

((parameters
  (_) @parameter.inner
  . ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

(parameters
  . ["(" ","] @_start
  (_) @parameter.inner @parameter.outer
  . ")" @_end)

((array
  (_) @parameter.inner
  . ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

(array
  . ["[" ","] @_start
  (_) @parameter.inner @parameter.outer
  . "]" @_end)
