;; extends

;; Concerning blocks handling
(call method: (identifier) @method @name
      (#match? @method "concerning")
      arguments: (argument_list
                   [(string
                      (string_content) @name)
                    (simple_symbol) @name
                    ])
      (#set! "kind" "Module")
      ) @type

;; Rails routes file
(call receiver: (call) @receiver @name
      (#match? @receiver "Rails.application.routes")
      method: (identifier) @method @_
      (#match? @method "draw")
      (#set! "kind" "Module")
      ) @type

;; Ideally, this would be a nested query under the above, but (_)* still doesn't work in neovim
(call method: (identifier) @method
      (#any-of? @method "resources" "resource" "get" "post" "patch" "put" "delete" "root" "collection" "member")
      arguments: (argument_list
                   [(string
                      (string_content) @name)
                    (simple_symbol) @name
                    ])?
      (#set! "kind" "Method")
      ) @type

(body_statement
  (call
    method: (identifier) @id
    (#any-of? @id "attr_reader" "attr_writer" "attr_accessor")
    arguments: (argument_list
                 (
                  (_) @type @name
                  (#gsub! @name "^:(.*)" "%1")
                  (#set! "kind" "Method")
                  )
                 )
    )
  )

(body_statement
  (call
    method: (identifier) @scope_node
    (#any-of? @scope_node "private" "protected")
    arguments: (argument_list
                 (call
                   method: (identifier) @id
                   (#any-of? @id "attr_reader" "attr_writer" "attr_accessor")
                   arguments: (argument_list
                                (
                                 (_) @type @name
                                 (#gsub! @name "^:(.*)" "%1")
                                 (#set! "kind" "Method")
                                 (#set! "scope" "private")
                                 )
                                )
                   )
                 )
    )
  )

(body_statement
  (call
    method: (identifier) @scope_node
    (#eq? @scope_node "public")
    arguments: (argument_list
                 (call
                   method: (identifier) @id
                   (#any-of? @id "attr_reader" "attr_writer" "attr_accessor")
                   arguments: (argument_list
                                (
                                 (_) @type @name
                                 (#gsub! @name "^:(.*)" "%1")
                                 (#set! "kind" "Method")
                                 )
                                )
                   )
                 )
    )
  )

(assignment
  left: (constant) @name
  (#set! "kind" "Constant")
) @type
