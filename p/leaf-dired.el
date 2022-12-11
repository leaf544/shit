;; --- * leaf-dired.el * ---

;;; Code

(setq dired-listing-switches "-lAh--group-directories-first")

(defun leaf-dired::no-extension ()
  (interactive)
  (dolist (file (directory-files default-directory nil "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)"))
    (if (file-name-extension file)
	(rename-file file (substring file 0 (string-search "." file))))))

(defvar unknown-formats-alist
  '(
    ("mp4" . "celluloid ")
    ("mp3" . "celluloid ")
    ("pdf" . "firefox ")
    ("htm" . "firefox ")
    ("webp" . "firefox ")
    ("xhtml" . "firefox ")
    ("html" . "firefox ")
    ("mov" . "celluloid ")
    )
    "The CDR of each cons is the command to run on the file with
  the corresponding extension ")

(defun leaf-dired::find-file (old &rest args)
  (let ((extension (file-name-extension (car (dired-get-marked-files)))))
    (if (assoc extension unknown-formats-alist)
	(cond
	 ((equal system-type 'windows-nt)
	  
	    (dired-do-shell-command (concat "\"" (car (dired-get-marked-files)) "\"")
				    nil (dired-get-marked-files))
	  
	  )
	 ((equal system-type 'gnu/linux)

	  (start-process-shell-command
	   (car (assoc (file-name-extension (car (dired-get-marked-files))) unknown-formats-alist))
	   nil
	   (concat (cdr (assoc (file-name-extension (car (dired-get-marked-files))) unknown-formats-alist))
		   (car (dired-get-marked-files))
		   )
	   )
	  )
	 )
      (apply old args))))

(add-function :around (symbol-function 'dired-find-file) #'leaf-dired::find-file)

(defvar colorize-dired nil)

(defvar dired-extension-colors-alist
  '(("exe" . ((t (:foreground "green"))))
    ("cpp" . ((t (:foreground "teal"))))
    ("pdf" . ((t (:foreground "DarkOliveGreen2"))))
    ("html" . ((t (:foreground "brown"))))
    ("org" . ((t (:foreground "dark sea green"))))
    ("jpg" . ((t (:foreground "light slate blue"))))
    ("mp4" . ((t (:foreground "DarkOliveGreen4"))))
    ("mp3" . ((t (:foreground "orange"))))
    ))

(defun leaf-dired::color-time ()
  (interactive)
  ;;"[0-9]+-[0-9]+ [0-9]+:[0-9]+\\|[0-9]+-[0-9]+-[0-9]+"
  (highlight-regexp "[0-9]+-[0-9]+ [0-9]+:[0-9]+\\|\\([0-9]+-[0-9]+-[0-9]+\\)\s" 'info-xref-visited))

(defun leaf-dired::color-extensions ()
  (interactive)
  (let ((inhibit-read-only t))
    (while (re-search-forward "\\.[a-z]+.$" nil t nil)
      (search-backward ".")
      (goto-char (1+ (point)))
      (save-excursion
	(put-text-property (point) (point-at-eol)
			   'font-lock-face
			   (cdr (assoc
				 (buffer-substring (point) (point-at-eol))
				 dired-extension-colors-alist)))))))
(when colorize-dired
  ;;(add-hook 'dired-after-readin-hook #'leaf-dired::color-extensions)
  (add-hook 'dired-after-readin-hook #'leaf-dired::color-time))

(defun lambda-form (string)
  (let ((form (make-list (string-width string) 0))
	(iter 0))
    (seq-doseq (char string)
      (setf (nth iter form) char)
      (cl-incf iter))
    form))

(defmacro construct-kmacro-lambda-form (extension where)
  `[?* ?% ,@(lambda-form extension) return ?R ,@(lambda-form where) return])

;;(macroexpand '(construct-kmacro-lambda-form ".txt" "~/txt/"))

(defvar dired-move-alist
  '((".txt" . "~/txt/")
    (".pdf" . "~/pdf/")
    (".mp4" . "~/media/video/")
    (".mp3" . "~/media/audio/")
    (".zip" . "~/archive/")
    (".rar" . "~/archive/")
    (".tar" . "~/archive/")
    (".xz" . "~/archive/")
    (".exe" . "~/exes/")
    (".jar" . "c:/Users/leaf/AppData/Roaming/.minecraft/")
    (".html" . "~/r/")
    (".htm" . "~/r/")    
    (".png" . "~/pic/")
    (".webp" . "~/pic/")
    (".jpg" . "~/pic/")
    )
  )

(defun leaf-dired::make-move-macros ()
  (dolist (o dired-move-alist)
    (unless (file-exists-p (cdr o))
      (make-directory (cdr o)))
    (eval `(fset
	    ',(intern
	       (format "%s-move"
		       (substring (car o)
				  1)))
	    (kmacro-lambda-form
	     (eval `(construct-kmacro-lambda-form
		     ,(car o)
		     ,(cdr o)
		     ))
	     0
	     "%d"
	     )
	    ))
    )
  )

(leaf-dired::make-move-macros)

(defvar dired-hide-details-dirs
  '("e:/media/audio/"
    "e:/pdf/"
    "e:/w/"
    )
  )

(add-hook 'dired-after-readin-hook #'(lambda ()
				       (dolist (o dired-hide-details-dirs)
					 (if (string-search o dired-directory)
					     (dired-hide-details-mode)))
				       ))


;; Temporary
(defadvice dired-find-file-other-window (after dffow activate)
  (other-window 1))

(provide 'leaf-dired)
