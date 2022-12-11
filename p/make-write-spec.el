(defmacro write::make-write-spec (ob)
  `(let ((code 
	 "KGZzZXQgCiAgICAgICMnKGxhbWJkYSAoc3RyaW5nKQoJICAoZm9ybWF0LXNwZWMgc3RyaW5nCgkJ
ICAgICAgIGAoKD9hIC4gLChhbGlzdC1nZXQgJ2FsaWFzIG9iKSkKCQkJICg/cCAuICwoYWxpc3Qt
Z2V0ICdwYXRoIG9iKSkKCQkJICg/ZiAuICwoYWxpc3QtZ2V0ICdzY2hlbWEgb2IpKQoJCQkgKD9l
IC4gLChhbGlzdC1nZXQgJ2V4dGVuc2lvbiBvYikpCgkJCSAoP2kgLiAsKGFsaXN0LWdldCAnaWRl
bnRpZmllciBvYikpCgkJCSAoP2IgLiAsKGFsaXN0LWdldCAnaWRlbnRpZmllciBvYikpCgkJCSAp
KQoJICApCiAgICAgICkK"
	 )
	(func (symbol-name (gensym "write-spec-")))
	(replace (format "'%S" ob))
	)
    (with-temp-buffer
      (insert (base64-decode-string code))
      (goto-char (point-min))
      (goto-char 7)
      (insert (format "'%S" (intern func)))
      (perform-replace "ob"
		       replace
		       nil nil nil)
      (eval-region (point-min) (point-max)))
    (intern func)
    )
  )


(defmacro write::make-write-spec (ob)
  `(let ((code 
	 "KGZzZXQgCiAgICAgICMnKGxhbWJkYSAoc3RyaW5nKQoJICAoZm9ybWF0LXNwZWMgc3RyaW5nCgkJ
ICAgICAgIGAoKD9hIC4gLChhbGlzdC1nZXQgJ2FsaWFzIG9iKSkKCQkJICg/cCAuICwoYWxpc3Qt
Z2V0ICdwYXRoIG9iKSkKCQkJICg/ZiAuICwoYWxpc3QtZ2V0ICdzY2hlbWEgb2IpKQoJCQkgKD9l
IC4gLChhbGlzdC1nZXQgJ2V4dGVuc2lvbiBvYikpCgkJCSAoP2kgLiAsKGFsaXN0LWdldCAnaWRl
bnRpZmllciBvYikpCgkJCSAoP2IgLiAsKGFsaXN0LWdldCAnaWRlbnRpZmllciBvYikpCgkJCSAp
KQoJICApCiAgICAgICkK"
	 )
	(func (symbol-name (gensym "write-spec-")))
	(replace (format "'%S" ob))
	)
    (with-temp-buffer
      (insert (base64-decode-string code))
      (goto-char (point-min))
      (goto-char 7)
      (insert (format "'%S" (intern func)))
      (perform-replace "ob"
		       replace
		       nil nil nil)
      (eval-region (point-min) (point-max)))
    (intern func)
    )
  )
