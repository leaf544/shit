(defvar scripture-motion-regexp "[[:digit:]]:[[:digit:]]"
  "Regexp for verse motion")

(defun leaf/scripture/next-verse (arg)
  (interactive "p")
  (dotimes (i arg)
    (end-of-line)
    (re-search-forward scripture-motion-regexp nil t)
    (beginning-of-line)))

(defun leaf/scripture/previous-verse (arg)
  (interactive "p")
  (dotimes (i arg)
    (previous-line)
    (re-search-backward scripture-motion-regexp nil t)
    (beginning-of-line)))

(define-derived-mode scripture-mode special-mode "Scripture"
  "Mode for scripture related needs."
  (setq buffer-read-only t)
  (define-key scripture-mode-map (kbd "<down>") #'leaf/scripture/next-verse)
  (define-key scripture-mode-map (kbd "<up>") #'leaf/scripture/previous-verse)
  (define-key scripture-mode-map (kbd "n") #'leaf/scripture/next-verse)
  (define-key scripture-mode-map (kbd "p") #'leaf/scripture/previous-verse))

(defun leaf/quran/goto-verse ()
  "Go to a Qur'anic verse."
  (interactive)
  (let* ((look-for (read-string "Verse: "))
	 (components (split-string look-for ":")))
    (beginning-of-buffer)
    (find-file (concat "~/quran/"
		       (if (length< (car components) 2)
			   (concat "0" (car components))
			 (car components))
		       ".txt"))
    (search-forward look-for)
    (beginning-of-line)))

;;(defalias 'g #'leaf/quran/goto-verse)

(provide 'leaf-scripture)
