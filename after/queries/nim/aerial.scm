;; extends

(const_section
  (variable_declaration
    (symbol_declaration_list
      (symbol_declaration
        name: (_) @name)
      )
    ) @symbol
  (#set! "kind" "Constant"))

(let_section
  (variable_declaration
    (symbol_declaration_list
      (symbol_declaration
        name: (_) @name
        )
      )
    ) @symbol
  (#set! "kind" "Variable"))

(var_section
  (variable_declaration
    (symbol_declaration_list
      (symbol_declaration
        name: (_) @name
        )
      )
    ) @symbol
  (#set! "kind" "Variable"))

((proc_declaration
   name: (_) @name) @symbol
 (#set! "kind" "Function"))

((template_declaration
   name: (_) @name) @symbol
 (#set! "kind" "Constructor"))

; A version that doesn't show type in the outline
; ((parameter_declaration
;    (symbol_declaration_list
;      (symbol_declaration
;        name: (_) @name
;        )
;      )
;    ) @symbol (#set! "kind" "Property"))

((parameter_declaration) @name @symbol (#set! "kind" "Property"))

(generic_parameter_list
  (parameter_declaration
    (symbol_declaration_list
      (symbol_declaration) @name @symbol)
    (#set! "kind" "TypeParameter"))
  )

(import_statement
  (expression_list
    (_) @name @symbol
    (#set! "kind" "Package"))
  )

(include_statement
  (expression_list
    (_) @name @symbol
    (#set! "kind" "Package"))
  )

((type_declaration
   (type_symbol_declaration
     name: (_) @name)
   (enum_declaration)
   ) @symbol
 (#set! "kind" "Enum"))

((type_declaration
   (type_symbol_declaration
     name: (_) @name)
   (object_declaration)
   ) @symbol
 (#set! "kind" "Class"))

(enum_field_declaration
  (symbol_declaration
    name: (_) @name) @symbol
  (#set! "kind" "EnumMember"))

((while
   condition: (_) @name
   (#gsub! @name "^" "while ")
   ) @symbol
 (#set! "kind" "Boolean"))

((for
   left: (_) @name
   (#gsub! @name "^" "for ")
   ) @symbol
 (#set! "kind" "Boolean"))

((when
   condition: (_) @name
   ) @symbol
 (#gsub! @name "^" "when ")
 (#set! "kind" "Boolean"))

((if
   condition: (_) @name
   ) @symbol
 (#gsub! @name "^" "if ")
 (#set! "kind" "Boolean"))

(_
  alternative: (elif_branch
                 condition: (_) @name
                 ) @symbol
  (#gsub! @name "^" "elif ")
  (#set! "kind" "Boolean"))

(_
  alternative: (else_branch) @name @symbol
  (#set! @name "text" "else")
  (#set! "kind" "Boolean"))

((case
   value: (_) @name
   (#gsub! @name "^" "case ")
   ) @symbol
 (#set! "kind" "Enum"))

(case
  (of_branch
    values: (_) @name
    ) @symbol
  (#set! "kind" "EnumMember")
  (#gsub! @name "^" "of "))

(case
  (else_branch) @symbol @name
  (#set! "kind" "EnumMember")
  (#set! @name "text" "else"))

((call
   function: (_) @name
   (argument_list
     (statement_list))
   ) @symbol
 (#set! "kind" "Interface"))
