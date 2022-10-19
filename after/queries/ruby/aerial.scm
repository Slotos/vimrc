;; extends

;; Concerning blocks handling
(call method: (identifier) @method @name
      (#match? @method "concerning")
      arguments: (argument_list
                   [(string
                      (string_content) @name)
                    (simple_symbol) @name
                    ])?
      ) @type
