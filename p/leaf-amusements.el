(require 'color)
(require 'ido)

(defalias 'cr 'ido-completing-read)

(defun l-set-default (size)
  (interactive "M")
  (set-face-attribute 'default nil :height (string-to-number size)))

(defun espeak (say)
  (interactive "M")
  (start-process "espeak" nil "espeak" (string-replace " " "_" say)))

(add-to-list 'exec-path "C:/Users/leaf/Downloads/nircmd-x64/nircmdc.exe")

(defun discord-emote ()
  (interactive)
  (let* ((dir (expand-file-name "~/emotes/"))
	 (emote (cr "Emote: " (directory-files dir
					       nil
					       directory-regexp)))
	 (final (concat dir emote)))

    (async-shell-command (concat "nircmdc clipboard copyimage " dir emote) nil nil)
    
    ;; (start-process "do" "ok" "nircmdc" (concat "clipboard copyimage " dir emote))
    ;; (call-process-shell-command )
    ;; (call-process-shell-command (concat "nircmdc clipboard copyimage " dir emote))
    )
  
    )
(defalias 'de #'discord-emote)

(defun get-meme ()
  (interactive)
  (let* ((dir (expand-file-name "~/memes/"))
	 (meme (cr "Meme: " (directory-files dir
					     nil
					     directory-regexp)))
	 (final (concat dir meme)))
    
    (async-shell-command (concat "nircmdc clipboard copyimage " dir meme) nil nil)))

(defalias 'gm #'get-meme)

(defun complement-color (color)
  (interactive "X")
  (kill-new (substring (color-complement-hex color) 0 7)))

(defun current-streak ()
  (interactive)
  (let ((msg (format-message
	      "On day %s, Abstained for %s days"
	      (- (length (get-diaries)) 77)
	      (- (length (get-diaries)) 78)
	      )))
    (if (called-interactively-p)
	(message msg)
      (insert (concat msg "\n\n"))
      ))
  )

(defun s-same-p (str1 str2)
  (catch 'result
    (if (null (= (abs (- (string-width str1) (string-width str2))) 0))
	(throw 'result nil))
    (dotimes (n (string-width str1))
      (let ((i (elt str1 n))
	    (i2 (elt str2 n)))
	(if (eq i i2)
	    nil
	  (if (= (abs (- i i2)) 32)
	      nil
	    (throw 'result nil)
	    ))))
    (throw 'result t))
  )

(defun get-common-words-in-file (file)
  (let ((common-words '()))
    (with-temp-buffer
      (insert-file-contents file)
      (while (forward-word)
	(let ((word (thing-at-point 'word t)))
	  (when (length> word 2)
	    (if (assoc word common-words) 
		(setcdr (assoc word common-words ) (1+ (cdr (assoc word common-words ))))
	      (add-to-list 'common-words (cons word 1))))
	  ))
      )
    (sort common-words #'(lambda (a b) (> (cdr a) (cdr b)))))  )

(defun get-common-words-in-directory (dir)
  (interactive "D")
  (let ((common-words '()))
    (dolist (file (dirf dir))
      (with-temp-buffer
	(insert-file-contents file)
	(while (forward-word-strictly)
	  (let ((word (thing-at-point 'word t)))
	    (when (length> word 2)
	      (if (assoc word common-words)
		  (setcdr (assoc word common-words) (+ (cdr (assoc word common-words)) 1))
		(add-to-list 'common-words (cons word 1))))
	    ))))
    (setq common-words (sort common-words #'(lambda (a b) (> (cdr a) (cdr b)))))
    (if (called-interactively-p)
	(message "%s" common-words)
      common-words)))

(defun get-common-words ()
  (interactive)
  (if (buffer-file-name)
      (message "%s" (get-common-words-in-file (buffer-file-name)))
    (call-interactively #'get-common-words-in-directory))
  )

(set (gensym (concat "file-common-words")) "lol")

(defalias 'cs #'current-streak)

(defun from-now (origin hours &optional arg)
  (interactive "MOrigin: \nnHours: \nP")
  (setq origin-hour origin)
  (setq hour-stream "")
  
  (dotimes (i hours)
    (if (= (string-to-number origin-hour) 12)
        (setq origin-hour "0"))
    (setq origin-hour (number-to-string (+ (string-to-number origin-hour) 1)))

    (setq hour-stream (concat hour-stream origin-hour " "))
    )

  (if arg
      (insert hour-stream)
    (if (called-interactively-p 'interactive)
	(message hour-stream)
      hour-stream
      )
    ))

(setq split (split-string (from-now "08" 14) " "))

(setq from-now-template
      '(("Affirmations" ((t (:foreground "red"))) 2 5)
	("Meditation"  ((t (:foreground "orange"))) 5 8)
	;;("Posture Contemplation"  ((t (:foreground "blue"))) 5 6)
	)
      )

(setq final '())
(dotimes (th (length split))
  (dolist (o from-now-template)
    
    (if (member th o)
	(progn (add-to-list 'final
		 (propertize (concat (elt split th) " ")
			     'font-lock-face
			     (cadr o)
			     )
		 ))

      (add-to-list 'final
		   (propertize (concat (elt split th) " ")
			       'font-lock-face
			       'default
			       )
		   )
      )
    
    )
  )

(mapcar #'insert (reverse final))9 10 11 12 1 2 3 4 5 6 7 8  

(defun secret ()
  (interactive)
  (dolist (f (dirf))
    (with-temp-buffer
      (insert-file-contents f)
      (reverse-region (point-min) (point-max))
      (write-region (buffer-substring-no-properties (point-min) (point-max)) nil f)
      )
    )
  )

(defun colorize ()
  (interactive)
  (put-text-property (point) (point-at-eol) 'font-lock-face '(:foreground "maroon"))
  )

(defvar simple-gematria
  '(("a" 1)
    ("b" 2)
    ("c" 3)
    ("d" 4)
    ("e" 5)
    ("f" 6)
    ("g" 7)
    ("h" 8)
    ("i" 9)
    ("j" 10)
    ("k" 11)
    ("l" 12)
    ("m" 13)
    ("n" 14)
    ("o" 15)
    ("p" 16)
    ("q" 17)
    ("r" 18)
    ("s" 19)
    ("t" 20)
    ("u" 21)
    ("v" 22)
    ("w" 23)
    ("x" 24)
    ("y" 25)
    ("z" 26)
    ("A" 27)
    ("B" 28)
    ("C" 29)
    )
  )

(defun gematria (word)
  (interactive "MWord: ")
  (let ((total 0))
    (seq-do
     #'(lambda (a)
	 (cl-incf total (cadr (assoc (string a) simple-gematria)))
	 )
     word)
    (message "%s" total))
  )

;; jump to window buffer

(defun jw (buffer)
  (interactive (list
		(ido-completing-read
		 "Buffer: "
		 (ido-get-buffers-in-frames))
		))
  (select-window (get-buffer-window buffer))
  ;; (while (not (string= (buffer-name) buffer))
  ;;   (other-window 1))
  )

(provide 'leaf-amusements)
