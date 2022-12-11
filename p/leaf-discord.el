(defun discord (msg)
  (interactive "M")
  (kill-new msg)
  (start-process "discord" nil "autohotkey" "e:/s/disc.ahk")
  (call-interactively #'discord)
  )

(defalias 'dc #'discord)

(provide 'leaf-discord)
