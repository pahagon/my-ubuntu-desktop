; -*- mode: Lisp;-*-
;(require 'evil)
;(evil-mode t)

;(use-package evil
;  :ensure t
;  :init
;  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
;  (setq evil-want-keybinding nil)
;  :config
;  (evil-mode 1))
;
;(use-package evil-collection
;  :after evil
;  :ensure t
;  :config
;  (evil-collection-init))


(setq evil-want-integration t) ;; This is optional since it's already set to t by default.
(setq evil-want-keybinding nil)
(require 'evil)
(evil-mode t)
(when (require 'evil-collection nil t)
  (evil-collection-init))

