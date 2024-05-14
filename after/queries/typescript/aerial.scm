;; extends

(call_expression
  function: (_
              property: (property_identifier) @method @name (#any-of? @method "describe" "beforeEach"))
  arguments: (arguments
    (string
      (string_fragment) @name @string))?
  (#set! "kind" "Function")
  ) @symbol @selection
