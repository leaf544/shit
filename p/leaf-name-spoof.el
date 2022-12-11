(defvar frontend
  '(
    "DESKTOP"
    "PC"
    "XIAOMI"
    "TV"
    "LAPTOP"
    "SAMSUNG"
    "ANDROID"
    "IOS"
    )
  "List of device frontends"
  )

(defun get-prefix ()
  (nth (random (length frontend)) frontend))

(defun spoof-random-name ()
  (interactive)
  (kill-new
   (upcase (concat (get-prefix) "-" (make-temp-name (make-temp-name "")))))
  (message "%s" (car kill-ring)))

(defun spoof-create-name ()
  (interactive)
  (kill-new
   (upcase (concat (read-string "Prefix: ") "-" (make-temp-name (make-temp-name "")))))
  (message "%s" (car kill-ring)))

(provide 'leaf-name-spoof)
