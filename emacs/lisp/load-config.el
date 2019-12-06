(defun load-config (configs)
  (mapcar (lambda (c)
            (let ((config-file (expand-file-name (concat "config/" (symbol-name c) ".el") user-emacs-directory)))
              (if (file-exists-p config-file)
                  (load config-file)))) configs))

(provide 'load-config)

