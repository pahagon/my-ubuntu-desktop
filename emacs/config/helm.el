; -*- mode: Lisp;-*-
;It helps to rapidly complete file names, buffer names, or any other Emacs interactions requiring selecting an item from a list of possible choices.
(helm-mode t)
(global-set-key  (kbd "M-x")     'helm-M-x)
(global-set-key  (kbd "C-x C-f") 'helm-find-files)
(global-set-key  (kbd "C-x C-b") 'helm-buffers-list)

