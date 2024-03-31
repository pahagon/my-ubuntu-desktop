; -*- mode: Lisp;-*-
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpha" . "http://melpa.org/packages/") t)
(require 'ensure-packages-installed)
(ensure-packages-installed '(evil
                 use-package
                 evil-collection
                 flycheck
                 pkg-info
                 powerline
                 magit
                 markdown-mode
                 neotree
                 ;tabbar
                 helm
                 projectile
                 helm-projectile
                 counsel-projectile
                 gh
                 github-clone
                 perspective
                 ivy
                 swiper-helm
                 zenburn-theme
                 eshell-git-prompt
                 smartparens
                 clojure-mode
                 cider
                 alchemist
                 erlang
                 elixir-mode
                 projectile-rails
                 graphql-mode
                 npm-mode
                 js2-mode
                 nodejs-repl
                 helm-ag
                 terraform-mode
                 dockerfile-mode
                 kotlin-mode
                 gradle-mode
                 yaml-mode
                 markdown-mode
                 mocha))

(defvar bootstrap-version)
(let ((bootstrap-file
              (expand-file-name
                       "straight/repos/straight.el/bootstrap.el"
                               (or (bound-and-true-p straight-base-dir)
                                            user-emacs-directory)))
            (bootstrap-version 7))
   (unless (file-exists-p bootstrap-file)
        (with-current-buffer
                 (url-retrieve-synchronously
                           "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
                                    'silent 'inhibit-cookies)
                       (goto-char (point-max))
                             (eval-print-last-sexp)))
     (load bootstrap-file nil 'nomessage))

(require 'load-config)
(load-config '(emacs
           ivy
           dired
           backup-dir
           evil
           helm
           markdown-mode
           powerline
           window
           cider
           projectile
           neotree
           ;tabbar
           counsel-projectile
           perspective
           ;custom-file
           js
           smartparens
           elixir
           gradle-mode
           global-set-key
           yaml-mode
           asdf-vm
           evil-collection
           arduino-mode
           copilot
           hooks))

;;C-h f (or M-x describe-function) will show you the bindings for a command.
;;C-h b (or M-x describe-bindings) will show you all bindings.
;;C-h m (M-x describe-mode) is also handy to list bindings by mode.
;;C-h k (M-x describe-key) to show what command is bound to a key.
;;C-h k C-j to find out what command will be run by C-j
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(copilot zenburn-theme yaml-mode use-package terraform-mode swiper-helm smartparens projectile-rails powerline perspective npm-mode nodejs-repl neotree mocha markdown-mode kotlin-mode helm-projectile helm-ag graphql-mode gradle-mode github-clone flycheck evil-collection eshell-git-prompt erlang editorconfig dockerfile-mode counsel-projectile cider alchemist)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
