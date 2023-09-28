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
