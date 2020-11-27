;(or (file-exists-p package-user-dir)
;    (package-refresh-contents))

(defun ensure-packages-installed (packages)
  ;(package-refresh-contents)
  (mapcar (lambda (p) (unless (package-installed-p p)
                              (package-install     p))) packages))

(provide 'ensure-packages-installed)

