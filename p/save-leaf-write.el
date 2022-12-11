;; --- * leaf-write.el * ---

(require 'cl-lib)

(defconst diary-path (expand-file-name "~/w/"))
(defconst journal-path (expand-file-name "~/j/"))
(defconst ascetic-path (expand-file-name "~/ascetic/"))
(defconst diary-file-format (concat time-string-format ".org"))

(defvar diary-headers
  '("== SCHOOL =="
    "== REMINDERS =="
    )
  )

;; Might need some optimization

(defun get-diaries ()
  (seq-filter
	 (lambda (x)
	   (not (= (string-to-number (string (aref x 0))) 0))) 
	 (directory-files diary-path nil directory-regexp)))

(defun write-directory-p ()
  (string= default-directory (expand-file-name "~/w/")))

(defun leaf/diary/goto-write ()
  (interactive)
  (let ((diary (concat diary-path (format-time-string diary-file-format))))
    (find-file diary)
    (auto-fill-mode)
    ;; (when (and (not (search-forward "Abstained for" nil t))
    ;; 	       (fboundp 'current-streak)
    ;; 	       )
    ;;   (save-excursion
    ;; 	(goto-char (point-min))
    ;; 	(current-streak)
    ;; 	(save-buffer))
    ;;   )
    (save-excursion
      (goto-char (point-min))
      (unless (search-forward "== " nil t)
	(message "no headers")
	(dolist (o diary-headers)
	  (insert (concat o "\n")))
	))
    ))

(defun leaf/journal/goto-journal ()
  (interactive)
  (let ((journal (concat journal-path (format-time-string diary-file-format))))
    (find-file journal)
    (auto-fill-mode)
    ;; (when (and (not (search-forward "Abstained for" nil t))
    ;; 	       (fboundp 'current-streak)
    ;; 	       )
    ;;   (save-excursion
    ;; 	(goto-char (point-min))
    ;; 	(current-streak)
    ;; 	(save-buffer))
    ;;   )
    ))

(defun leaf/diary/goto-write-read-only ()
  (interactive)
  (find-file-read-only (concat diary-path (format-time-string diary-file-format))))

;; Might need some cleaning

(defun leaf/diary/last-diary ()
  "Go to yesterday's diary"
  (interactive)
  (let* ((default-directory diary-path)
	 (diaries (get-diaries))
	 (last
	  (car
	   (cl-loop for x from 0 to (length diaries)
		    when (string= (nth (1+ x) diaries) (buffer-name))
		    collect x))))
    
    (find-file (and (write-directory-p) (nth last diaries)))))

;; Intern in a let should be hapenning here

(defun leaf/diary/goto-diary ()
  (interactive)
  (find-file (concat diary-path (completing-read "Goto Diary: " (butlast (funcall 'get-diaries) 2)))))

(defalias 'd #'leaf/diary/goto-write)
(defalias 'dr #'leaf/diary/goto-write-read-only)
(defalias 'ld #'leaf/diary/last-diary)
(defalias 'gd #'leaf/diary/goto-diary)

(defvar todo-list-file (expand-file-name "~/todo"))

(defun todo-list ()
  (interactive)
  (find-file todo-list-file))

(defun reminders ()
  (interactive)
  (find-file "~/reminders"))

(defalias 'r #'reminders)

(defalias 'td #'todo-list)

(defun leaf/diary/goto-ascetic ()
  (interactive)
  (find-file (concat ascetic-path (format-time-string diary-file-format))))

(defalias 'a #'leaf/diary/goto-ascetic)

(defalias 'ho #'(lambda ()
		  (interactive)
		  (find-file "~/w/HORNYRIGHTNOW")
		 ))

(defalias 'f #'(lambda ()
		  (interactive)
		  (find-file "~/w/fog.org")
		 ))

;; (define-derived-mode write-mode fundamental-mode "Write"
;;   "Ever just need a temporary buffer to write stuff?"
;;   (define-key write-mode-map (kbd "C-x C-s") #'ignore)
;;   (define-key write-mode-map (kbd "C-x C-s") #'ignore)
;;   )

;; (defun leaf/temp-buffer ()
;;   (interactive)
;;   (switch-to-buffer-other-frame (make-temp-name "write"))
;;   (write-mode)
;;   )

;; (defalias 'tb #'leaf/temp-buffer)

;; (defun leaf/save-temp-buffer ()
;;   (interactive)
;;   (kill-region (point-min) (point-max))
;;   (delete-frame)
;;   )

(defun leaf/rand-header ()
  (interactive)
  (org-meta-return)
  ;;(org-demote)
  (insert (upcase (make-temp-name "")))
  )

(defalias 'q #'leaf/rand-header)
(defalias 'j #'leaf/journal/goto-journal)

(defun leaf/write-up ()
  (interactive)
  (let ((p1 (point)))
    (insert "WRITEUP")
    (narrow-to-region p1 (point))))

(defalias 'w #'leaf/write-up)

      ;; (setq to-print 
      ;; 	    `(fset
      ;; 	      ',(make-symbol key)
      ;; 	      (lambda ()
      ;; 		(interactive)
      ;; 		(write::jump-to-write ,path ,format))
      ;; 	 ))
      ;; (eval ))
    ;; We gotta clean this shit up
     ;; (unless
     ;; 	 (boundp
     ;; 	  (make-symbol
     ;; 	  (concat
     ;; 	   (format "%s" ',write)
     ;; 	   "-select-hook"
     ;; 	   ))
     ;; 	  )
     ;;   (intern
     ;; 	(concat
     ;; 	 (format "%s" ',write)
     ;; 	 "-select-hook"
     ;; 	 )
     ;; 	)
     ;;   )

(with-temp-buffer
      (insert
       (format "%S"
	       `(run-hooks
		 ',(make-symbol
		  (concat
		   (format "%s" write)
		   "-select-hook")))
	       ))
      (eval-region (point-min) (point-max)))

    (with-temp-buffer
      (insert
       (format "%S"
	       `(run-hooks
		 ',(make-symbol
		    (concat
		     (format "%s" write)
		     "-select-hook")))
	       ))
      (eval-region (point-min) (point-max)))
