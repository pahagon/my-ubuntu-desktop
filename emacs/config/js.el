(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

(add-hook 'js-mode-hook (lambda ()
			  (define-key js-mode-map (kbd "<f5>") 'mocha-test-file)))
(add-hook 'js2-mode-hook (lambda ()
			   (setq js2-basic-offset 2)))
