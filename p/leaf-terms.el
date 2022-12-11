;; --- * leaf-terms.el * ---

;; Last Modified: 11/14/2022

(defvar terms--supported-modes '(org-mode text-mode fundamental-mode))
(defvar-local terms-string "")

(defmacro when-not-found (string &rest body)
  `(unless (search-forward ,string nil t nil)
     (progn ,@body)
    ))

(define-derived-mode terms-mode tabulated-list-mode "Terms"
  nil
  nil
  (define-key terms-mode-map (kbd "m") #'terms--mark-term)
  (define-key terms-mode-map (kbd "d") #'terms--done)
  (define-key terms-mode-map (kbd "w") #'terms--append)
  ;;(define-key terms-mode-map (kbd "s") #'terms--sort-by-occurence)
  )

(defun terms--entry (&optional pos)
  (tabulated-list-get-id pos))

(defun terms--mark-term ()
  (interactive)
  ;; Use something other than `add-to-list'
  (add-to-list 'marked-terms (terms--entry))
  (setq-local terms-string (format "%s" marked-terms))
  (tabulated-list-set-col 0 (propertize "M" 'font-lock-face 'info-xref-visited) t)
  (next-line))

;; This needs to be a general exit function
(defun terms--done ()
  (interactive)
  (let ((final terms-string))
    (with-current-buffer target-buffer
      (when-not-found "# TERMS:"
		      (save-excursion
			(goto-char (point-max))
			(insert (format "# TERMS: %s" final))))
      (save-buffer)))
  (kill-buffer-and-window))

(defun terms--append ()
  (interactive)
  (setq-local terms-string (concat (read-string "Append: " terms-string))))

(defun terms--generate-entries (file)
  (let ((entries '())
	(tlist (reverse (seq-remove
		#'(lambda (o)
		    (member (car o) ignore-list))
		(get-common-words-in-file file)))))
    
    (dolist (word tlist)
      (add-to-list 'entries
		   `(,(car word) [" " ,(car word) ,(number-to-string (cdr word))])
		   ))
    entries))

(defun terms (buffer)
  (interactive (list (current-buffer)))
  (with-current-buffer (switch-to-buffer-other-window
			(generate-new-buffer-name "*Terms*"))
    (terms-mode)
    (setq-local tabulated-list-format
		[
		 ("*" 3 nil)
		 ("Term" 20 nil)
		 ("Occurence" 10 nil)
		 ]
		)
    (setq-local tabulated-list-entries
		(terms--generate-entries (buffer-file-name buffer)))

    (setq-local target-buffer buffer)
    (setq-local marked-terms '())

    (tabulated-list-init-header)
    (tabulated-list-print)
    (hl-line-mode)
    ))

(defun terms--has-terms-tag-p (file)
  (catch 'term 
    (with-temp-buffer
      (insert-file-contents file)
      (if (search-forward "# TERMS:" nil t nil)
	  (throw 'term (buffer-substring (point-at-bol) (point-at-eol)))
	)
      )
    ))

(provide 'leaf-terms)

