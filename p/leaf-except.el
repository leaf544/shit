;; --- * leaf-except.el * ---

(defun leaf/except-close ()
  "Kills all buffers except the one you're working in."
  (interactive)
  (mapc #'kill-buffer (delq (current-buffer) (buffer-list)))
  (message "Killed all buffers except this one"))

(defun leaf/except-close-except-windows ()
  "Kills all buffers except visible buffer windows."
  (interactive)
  (mapc #'kill-buffer
	(seq-filter
	 (lambda (elt) (not (memq elt (mapcar 'window-buffer (window-list)))))
	 (buffer-list)))
  (message "Killed all buffers except visible buffer windows"))

(defun leaf/kill-all-buffers ()
  "Kill all buffers"
  (interactive)
  (mapc #'kill-buffer (buffer-list))
  (message "Killed all buffers"))

(defalias 'ec #'leaf/except-close)
(defalias 'wc #'leaf/except-close-except-windows)
(defalias 'ka #'leaf/kill-all-buffers)

(provide 'leaf-except)
