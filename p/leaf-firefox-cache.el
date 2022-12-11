;; --- * leaf-firefox-cache.el * ---

;; Author: https://github.com/leaf544
;; Created: 7/7/2022
;; Keywords: Convenience, Fun

;;; Commentary

;; Convert firefox cache files to their respective supportable
;; formats

(require 'leaf-meta)

(defvar supported-content-types
  '(("content-type: image/webp" . "webp")
    ("content-type: image/jpeg" . "png")
    ("content-type: image/png" . "png")
    ("content-type: image/mp3" . "mp3")
    ("content-type: image/mp4" . "mp4")
    )
  "Desired content-types.")

(setq no-content 0)

(defun get-cache-files (dir)
  (or (and
       (cdr (dired-get-marked-files)) (dired-get-marked-files))
      dir))

(defun cache-directory? (dir)
  "This function is very liberal in deciding if a directory is
indeed a cache directory"
  (and
   (length>
    (car
     (dirf dir))
    20)
   (length>
    (dirf dir) 100)
   t))

(defun which-ext ()
  "Returns nil if buffer has no valid 'content-type' specifier"
  (cdr (assoc (progn
		(search-forward "content-type: " nil t)
		(buffer-substring-no-properties (point-at-bol) (point-at-eol)))
	      supported-content-types)))

(defun delete-irrelevant-files ()
  "Delete all files that have no 'content-type' specifier."  
  (with-directory (f default-directory)
		  (with-temp-buffer
		    (insert-file-contents f)
		    (if (and (null (search-forward "content-type: " nil t)) (cache-directory?))
			(progn
			  (delete-file f)
			  (setq no-content (1+ no-content))))))
  (message "Deleted %s files" no-content)
  (setq no-content 0))

(defun leaf-firefox-cache (dir)
  "Convert all cache files to their respective supported formats."
  (interactive
   (list
    default-directory))
  (cond ((cache-directory? dir)
	 (and (yes-or-no-p "Delete irrelevant files? ") (delete-irrelevant-files))
	 (with-directory (file (get-cache-files dir))
			 (with-temp-buffer
			   (insert-file-contents file)
			   (if (which-ext)
			       (rename-file file (concat file "." (which-ext)))
			     (delete-file file)))))
	(t (message "Not a cache directory"))))

(provide 'leaf-firefox-cache)
