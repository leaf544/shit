;; --- * leaf-write.el * ---

;;; Commentary

;;; Code

(require 'json)
(require 'dash)

(defvar schema-file "~/p/schema.json")

(defvar global-write-select-hook '())
(defvar write-intern-hook '())

(defun write--read-schema ()
  (let ((json-object-type 'alist))
    (json-read-file
     (expand-file-name
      schema-file))
    )
  )

(defmacro make-spec (name alist)
  `(let ((func (if (null ,name)
		   (intern (make-temp-name "s"))
		 (intern ,name))))
     (fset
      func
      (lambda (string)
	(format-spec string
		     ,alist)))
     func))

(defsubst write--get-attr (schema write attr)
  (alist-get attr (alist-get write schema)))

;; Consider condensing this

;;(soBQDH2 "%p")

(defmacro write--intern-write-up (obj)
  `(progn
     (intern (format "%s-select-hook" (car ,obj)))
     ;; Creating a function that gets all the children of write
     (eval `(fset
	     (intern
	      ,(format "get-%ss" (car ,obj)))
	     (lambda ()
	       (interactive)
	       (directory-files
		,(alist-get 'path obj)
		t
		(format "\\%s%s$" ,(alist-get 'identifier obj) ,(alist-get 'extension obj)) nil nil)
	       )))
     ;; Create a function that gets the nth child from current write of write
     (eval `(fset
	     (intern ,(format "l%s" (alist-get 'alias obj)))
	     (lambda (&optional arg)
	       (interactive "P")
	       ;; Another way of checking if we're in a write buffer
	       ;; is to check for the existence of write local
	       ;; variables
	       (let* ((func (symbol-function (intern ,(format "get-%ss" (car obj)))))
		      (coll (funcall func))
		      (curr (or
			     (and (boundp 'write-path) (buffer-file-name))
			     (car (last coll))
			     ))
		      (currpos (-elem-index curr coll))
		      (newpos (nth (1- currpos) coll)))

		 (find-file newpos)
		 
		 (message "Truth: %s" (boundp 'write-path))
		 (message "Current Buffer: %s" curr)
		 (message "Current Position: %s (%s)" currpos (nth currpos coll))
		 (message "New Position: %s" newpos)
		 
		 )
	       )
	     ))
     ;; Creating alias
     (eval `(fset
	     (intern ,(alist-get 'alias obj))
	     (lambda ()
	       (interactive)
	       (write--jump-to-write (quote ,obj))
	       )))
     ))

(defun write--init (schema)
  (dolist (obj schema)
    (let ((path (write--get-attr schema (car obj) 'path)))
      (unless (file-exists-p path)
	(make-directory (expand-file-name path)))
      (write--intern-write-up obj)
      )))

(write--init (write--read-schema))

;; Hooks here

(add-hook 'journal-select-hook #'(lambda ()
				   (highlight-regexp "^..:.. [AM | PM]+"  'hi-blue)))

;; (add-hook 'grind-select-hook #'(lambda ()
;; 				 ;;(insert (format-time-string "* %m/%d/%Y\n"))
;; 				 (insert "* Agenda")
;; 				 ))

(provide 'leaf-write)

