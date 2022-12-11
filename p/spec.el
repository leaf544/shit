(fset 
      #'(lambda (string)
	  (format-spec string
		       `((?a . ,(alist-get 'alias ob))
			 (?p . ,(alist-get 'path ob))
			 (?f . ,(alist-get 'schema ob))
			 (?e . ,(alist-get 'extension ob))
			 (?i . ,(alist-get 'identifier ob))
			 (?b . ,(alist-get 'identifier ob))
			 ))
	  )
      )
