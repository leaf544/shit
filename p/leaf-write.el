;; --- * leaf-write.el * ---

;;; Commentary

;;; Code

(require 'json)
(require 'dash)
(require 'tabulated-list)

(defvar schema-file
  (let ((assumed (concat user-emacs-directory "schema.json")))
    (if (null (file-exists-p assumed))
	(make-empty-file assumed)
      assumed)))

(defvar global-write-select-hook '())
(defvar write-intern-hook '())

(defvar timeline-regexp "\\+[A-Z].+\\+$")
(defvar timeline-face 'link)

(defvar last-write-obj nil)
(defvar winfo-word-cap 18)

(defun write--read-schema ()
  (let ((json-object-type 'alist))
    (json-read-file
     (expand-file-name
      schema-file))
    )
  )

(defsubst write--get-attr (schema write attr)
  (alist-get attr (alist-get write schema)))

(defun write--jump-to-write (ob &optional file)
  (when-let* ((write (car-safe ob))
	      (path (alist-get 'path ob))
	      (alias (alist-get 'alias ob))
	      (format (alist-get 'schema ob))
	      (extension (alist-get 'extension ob))
	      (identifier (alist-get 'identifier ob))
	      (assumed (concat
			path
			(if (or current-prefix-arg (alist-get 'behaviour ob))
			    (kill-new (read-string "Title: "))
			  (format-time-string format))
			identifier
			extension
			))
	      
	      )
    (with-current-buffer (find-file assumed)
      (run-hooks global-write-select-hook)
      (run-hooks (intern (format "%s-select-hook" write)))))
  
  (when file
    (find-file file)
    ;;(setq-local write-path path)
    (run-hooks global-write-select-hook)
    (run-hooks (intern (format "%s-select-hook" (car-safe ob))))
    )
  )

;; Why can't we make `write--intern-write-up' a function?  The reason
;; we don't want to use a function is because fsetting evaluates ob as
;; if it were globally available

(defun write--intern-write-up (obj)
  (intern (format "%s-select-hook" (car obj)))
  (write--write-children obj)
  (write--goto-write-dir obj)
  (write--write-last-write-fun obj)
  (write--write-alias-fun obj)
  (write--make-winfo obj)
  )

(defun write--init (schema)
  (dolist (obj schema)
    (let ((path (write--get-attr schema (car obj) 'path)))
      (unless (file-exists-p path)
	(make-directory (expand-file-name path)))
      (write--intern-write-up obj)
      )))

;; Intern Functions

(defun write--write-children (obj)
  (fset
   (intern (format "get-%ss" (car obj)))
   `(𝛌 (&optional full)
      (interactive)
      (directory-files
       ,(alist-get 'path obj)
       full
       (format "\\%s%s$" ,(alist-get 'identifier obj) ,(alist-get 'extension obj)) nil nil)
      )))

(defun write--write-last-write-fun (obj)
   (fset
     (intern (format "l%s" (alist-get 'alias obj)))
     `(𝛌 (&optional arg)
       (interactive "p")
       (let* ((func (symbol-function (intern ,(format "get-%ss" (car obj)))))
	      (coll (funcall func t))
	      (curr
	       (or
		(and (string= (file-name-directory (or (buffer-file-name) "")) (expand-file-name ,(alist-get 'path obj)))
		     (nth (- (-elem-index (buffer-file-name) coll) (or arg 1)) coll))
		(car (last coll arg)))))
	 (write--jump-to-write nil curr)))))

(defun write--goto-write-dir (obj)
  (fset
   (intern (format "g%s" (alist-get 'alias obj)))
   `(𝛌 ()
      (interactive)
      (dired ,(alist-get 'path obj))
      )
   ))

(defun write--write-alias-fun (obj)
  (fset
   (intern (alist-get 'alias obj))
   `(𝛌 ()
      (interactive)
      (write--jump-to-write ',obj)
      )))

;; WInfo Mode

(defun write--make-winfo (obj)
  (fset
   (intern (format "i%s" (alist-get 'alias obj)))
   `(𝛌 ()
      (interactive)
      (write-info-mode ',obj))))

(defun winfo--generate-list-entries (list obj)
  (let ((entries '()))
    (dotimes (n (length list))
      (let* ((id (nth n list))
	     (full (concat (alist-get 'path obj) id))
	     ;; Yikes, this should be condensed, we should do the task
	     ;; at hand using cl-loop in a single swoop
	     (wlist
	      (ignore-errors
		(cl-loop for x in
			 (seq-remove
			  #'(𝛌 (o)
			      (member (car o) ignore-list))
			  (get-common-words-in-file full))
			 collect (car x) into values
			 finally return (mapconcat #'(𝛌 (o) o) (reverse (seq-take values winfo-word-cap)) " ")
			 )
		))
	     (words
	      (or (and (null (string-empty-p wlist)) wlist)
		  "EMPTY")
	      )
	     (entry `(,id [,(propertize id 'font-lock-face
				       (cond ((>= (file-attribute-size (file-attributes full)) 1000)
					      '((t (:foreground "tomato" :underline t)))
					      )
					     (t '((t (:foreground "gray75" :underline t))))))
			   ,(file-size-human-readable (file-attribute-size (file-attributes full)))
			   ,(format "%s" words)]))
	     )
	(add-to-list 'entries entry)
	(setq last-write-obj obj)
	)
      )
    entries))

(defun winfo--visit-file ()
  (interactive)
  (write--jump-to-write nil (concat (alist-get 'path last-write-obj) (tabulated-list-get-id))))

(defun winfo--sort ()
  (interactive)
  (setq-local tabulated-list-entries
	      (sort
	       tabulated-list-entries
	       #'(𝛌 (a b)
		   (>= (file-attribute-size (file-attributes
					     (concat (alist-get 'path last-write-obj) (car a))
					     ))
		       1500))))
  (revert-buffer))

(defun write-info-mode (obj)
  (with-current-buffer (switch-to-buffer (make-temp-name "w"))
    (write-info)
    (setq-local tabulated-list-entries
		(winfo--generate-list-entries
		 (funcall (intern (format "get-%ss" (car obj))))
		 obj
		 ))
    (setq-local tabulated-list-format
		[
		 ("Write" 25 nil)
		 ("Size" 15 nil)
		 ("Terms" 10 nil)
		 ])
    (tabulated-list-init-header)
    (tabulated-list-print)
    ))

(define-derived-mode write-info tabulated-list-mode "WInfo"
  "Simple write information viewer."
  nil
  (define-key write-info-map (kbd "RET") #'winfo--visit-file)
  (define-key write-info-map (kbd "s") #'winfo--sort))

(write--init (write--read-schema))
(load-file "~/p/ignore-list.el")

(add-hook 'dired-after-readin-hook #'(𝛌 () (highlight-regexp timeline-regexp timeline-face)))

(provide 'leaf-write)
