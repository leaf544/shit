;; --- * leaf-mark-open.el * ---

;; Created 7/7/2022

(require 'f)

(defvar mark-file
  (let ((file (concat user-emacs-directory "marked")))
    (unless (file-exists-p file)
      (make-empty-file file))
    file)
  "Where marked files are stored.")

(defun get-living-buffers ()
  (seq-filter
   (lambda (b)
     (buffer-file-name b))
   (buffer-list)))

(defun get-window-buffers ()
  (seq-filter
   (lambda (elt) (memq elt (mapcar 'window-buffer (window-list))))
   (buffer-list)))

(defun write-to-mark (obj append)
  (write-region obj nil mark-file append))

;; refun wasn't the devil after all, implement it later

(defmacro refun (name args &rest body)
  `(defun ,name (,@args)
     (interactive "i")
     ,@body
     (and (called-interactively-p) current-prefix-arg (restart-emacs))))

(refun leaf/mark-buffer-file (obj)
       (write-to-mark (concat (buffer-file-name obj) "\n") t))

(refun leaf/mark-directory (obj)
       (write-to-mark (concat default-directory "\n") t))

(refun leaf/mark-living-buffers (obj)
       (mapc #'leaf/mark-buffer-file (get-living-buffers)))

(refun leaf/mark-window-buffers (obj)
       (mapc #'leaf/mark-buffer-file (get-window-buffers)))
 
(defun mark-open-procedure-default-function ()
  (let ((marked
	 (split-string (f-read-text mark-file) "\n" t)))
    (when marked
      (mapc #'find-file marked)
      (write-to-mark "" nil))))

(defvar mark-open-procedure #'mark-open-procedure-default-function)

(defalias 'mf #'leaf/mark-buffer-file)
(defalias 'md #'leaf/mark-directory)
(defalias 'mlb #'leaf/mark-living-buffers)
(defalias 'mw #'leaf/mark-window-buffers)

(provide 'leaf-mark-open)
