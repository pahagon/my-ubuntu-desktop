; -*- mode: Lisp;-*-
(defun my-find-user-init-file () ;find and open init file
  (interactive)
  (find-file-other-window user-init-file))

(defun indent-file (file)
  "prompt for a file and indent it according to its major mode"
  (interactive "fWhich file do you want to indent: ")
  (find-file file)
  ;; uncomment the next line to force the buffer into a c-mode
  ;; (c-mode)
  (indent-region (point-min) (point-max)))

(global-linum-mode t)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-c I") 'my-find-user-init-file)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-projectile-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

