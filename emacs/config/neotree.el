; -*- mode: Lisp;-*-
(defun neotree-projectile-switch-project ()
  (interactive)
  (progn (neotree-dir (ignore-errors (counsel-projectile-switch-project)))))

;; Set the neo-window-width to the current width of the
;; neotree window, to trick neotree into resetting the
;; width back to the actual window width.
;; Fixes: https://github.com/jaypei/emacs-neotree/issues/262
(eval-after-load "neotree"
  '(add-to-list 'window-size-change-functions
                (lambda (frame)
                  (let ((neo-window (neo-global--get-window)))
                    (unless (null neo-window)
                      (setq neo-window-width (window-width neo-window)))))))

;;(setq neo-window-fixed-size nil)
(setq projectile-switch-project-action 'neotree-projectile-action)
(global-set-key  (kbd "C-, p")     'neotree-projectile-switch-project)
(global-set-key  (kbd "C-, n")     'neotree-dir)
(global-set-key  (kbd "C-, o")     'neotree-toggle)
(global-set-key  (kbd "C-, RET") 'neotree-enter)

