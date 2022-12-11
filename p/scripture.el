(require 'ido)

(defvar scriptures-directory
  '(
    "~/nt/"
    "~/ot/"
    )
  )

(defun scripture--intern-new-scripture ()
  (interactive)
  
  )

(defun scripture--prompt-book (book-dir)
  (concat book-dir
	  (ido-completing-read
	   "Book: "
	   (mapcar #'capitalize (directory-files book-dir nil directory-regexp)))))

(defun scripture--prompt-verse (verse)
  (interactive "MVerse: ")
  verse)

(setq directory-regexp "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)")

(defun scripture--goto-verse ()
  (interactive)
  
  (with-current-buffer (find-file
			(scripture--prompt-book "~/ot/"))
    (unless
	(and (search-forward (call-interactively #'scripture--prompt-verse) nil t)
	     (beginning-of-line))
      (message "Couldn't find verse"))))


