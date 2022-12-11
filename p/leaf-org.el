;; --- * leaf-org.el * ---

;; Code

(require 'org)
(require 'org-bullets)

(setq org-hide-emphasis-markers t)
(setq org-return-follows-link t)
(setq org-startup-folded nil)
(setq org-adapt-indentation t)

(setcdr (assoc 'file org-link-frame-setup) 'find-file)

(global-set-key (kbd "<f8>") #'org-agenda)
(setq-default org-todo-keywords
	      '((sequence "TODO" "TOMORROW" "STUDY"  "DONE"))
	      org-todo-keyword-faces
	      '(("TODO" . (:foreground "mint cream" :weight bold))
		("UNFINISHED" . (:foreground "RosyBrown1" :weight bold))
		("CANCELLED" . (:foreground "maroon" :weight bold))
		("DELAYED" . (:foreground "yellow" :weight bold))
		("CLAIM" . (:foreground "purple" :weight bold))
		("TOMORROW" . (:foreground "cyan1" :weight bold))
		("CONCLUSION" . (:foreground "gold" :weight bold))
		("QUIRK" . (:foreground "cornflower blue" :weight bold))
		("QUESTION" . (:foreground "sienna4" :weight bold))
		("STUDY" . (:foreground "aquamarine" :weight bold))
	      	))
(set-face-foreground 'org-headline-done (face-foreground 'font-lock-comment-face))

(global-set-key (kbd "<f9>") #'org-capture)
(setq org-capture-templates
      `(("t" "Todo" entry
	 (function buffer-file-name)
	 "* TODO %?\n" )
	("m" "Multi todo" entry
	 (function buffer-file-name)
	 "* TODO _%?_ [0/3] \n - [ ]\n - [ ]\n - [ ]")
	("g" "Grind" entry
	 (function grind--last)
	 "%(--current)** TODO %?"
	 :kill-buffer t)
	("c" "Claim" entry
	 (function buffer-file-name)
	 "* CLAIM %?\n** RESPONSE\n"
	 )
	("q" "Question" entry
	 (function buffer-file-name)
	 "* QUESTION %?\n** RESPONSE\n"
	 )))

(add-hook 'org-mode-hook #'auto-fill-mode)
(add-hook 'org-mode-hook 'org-bullets-mode)

(provide 'leaf-org)
