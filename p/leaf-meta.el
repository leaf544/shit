;; --- * leaf-macros.el * ---

;; Created 7/18/2022

;;; Commentary

;; Bunch of useful macros and functions that I wrote for personal use

(defmacro with-directory (pair &rest body)
  `(dolist (,(car pair) (directory-files ,(cadr pair) nil "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)"))
     ,@body))

(defun dirf (&optional dir)
  (directory-files
   (and (or dir default-directory)) nil "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)"))

(defun get-living-buffers ()
  "Return a list of file buffers"
  (seq-filter
   (lambda (b)
     (buffer-file-name b))
   (buffer-list)))

(defun display-living-buffers ()
  (interactive)
  (message "%s" (get-living-buffers)))

(defalias 'lb #'display-living-buffers)

(defalias 'buffer-exists? 'get-buffer)

(defun create-lambda-form (string)
  (interactive "MString: ")
  (let ((vector (make-vector (string-width string) 0))
	(iter 0))
    (seq-doseq (char string)
      (setf (aref vector iter) char)
      (cl-incf iter)
      )
    (message "%s" vector)
    (kill-new (format "%s" vector))))


;; (defmacro eval-sexps (&rest sexps)
  
;;   )

(provide 'leaf-meta)
