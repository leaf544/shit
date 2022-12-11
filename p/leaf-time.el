;; --- * leaf-time.el * ---

(defun with-in-bounds-p (n0 n1 num)
  (and (>= num n0)
       (<= num n1)))

(defvar *leaf-time-slots-template*
  '(("Task 1" ((t (:foreground "indian red"))) 2 3)
    ("Task 2" ((t (:foreground "red"))) 6 8)
    ("Brain Fog Research" ((t (:foreground "saddle brown"))) 11 13)
    ))

(defvar *time-slot-format* "%s ")

(defvar *leaf-time-global-origin-hour* nil)

(defun time-from-now (s n i v)
  (setf
   (nth s v)
   (format *time-slot-format* i))
  (if (< s n)
      (time-from-now
       (1+ s)
       n
       (or (and (= i 12) 1) (1+ i)) v))
  v)

(defun insert-time-slots (origin ahead &optional arg) 
  (interactive "nOrigin Hour: \nnHours Ahead: \nP")
  (if arg
      (f-write-text (number-to-string origin) 'utf-8 "~/time.el"))
  (let ((time-slots
	 (time-from-now
	  0
	  ahead
	  origin
	  (make-list (1+ ahead) 0)
	  ))
	(current (string-to-number (format-time-string "%I"))))
    (when (boundp '*leaf-time-slots-template*)
      (dolist (temp *leaf-time-slots-template*)
	(let* ((bounds
		`(,(elt temp 2)
		  ,(elt temp 3)))
	       (iter
		(or
		 (and (< (car bounds) ahead) (car bounds)) 0))
	       (prop (cadr temp)))
	  (while (with-in-bounds-p
		  (car bounds)
		  (cadr bounds)
		  iter)
	    (message "iter: %s" iter)
	    (setf (nth iter time-slots)
		  (propertize (nth iter time-slots) 'font-lock-face prop))
	    (cl-incf iter))
	  )))
    (mapcar #'insert time-slots)
    (mapcar #'(lambda (temp)
		(insert
		 (concat
		  "\n"
		  (propertize (car temp) 'font-lock-face
			      (cadr temp))
		  )
		 )
		)
	    *leaf-time-slots-template*)

    ))


;; (add-hook 'waking-up-hook (lambda ()
;; 			    (setq *leaf-time-global-origin-hour*
;; 				  (string-to-number
;; 				   (format-time-string "%I"))
;; 				  )
;; 			    ))

(defun show-time (&optional arg)
  (interactive "P")
  (progn
    (setq current-buffer (current-buffer))
     (pop-to-buffer
      (generate-new-buffer-name "*Time*")
      '(display-buffer-at-bottom . nil))
     (enlarge-window (+ -15
			(1+ (length *leaf-time-slots-template*))
			)
		     )
     (setq-local cursor-type nil)
     (cond ((string-empty-p (f-read-text "~/sleep"))
	    (insert-time-slots (string-to-number (format-time-string "%I")) 17 arg)
	    (f-write-text (format-time-string "%I") 'utf-8 "~/sleep"))
	   (t
	    (insert-time-slots (string-to-number (f-read-text "~/sleep")) 17) arg)
	    ;;(call-interactively #'insert-time-slots)
	   ))
  (read-only-mode 1)
  (jw current-buffer)
  )

(provide 'leaf-time)
