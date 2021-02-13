; -*- mode: Lisp;-*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpha" . "http://melpa.org/packages/") t)

(require 'ensure-packages-installed)
(ensure-packages-installed '(evil
			     powerline
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
			     magit
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
			     mocha))

(require 'load-config)
(load-config '(ivy
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
	       custom-file
	       js
	       smartparens
	       elixir
	       global-set-key
	       gradle-mode
	       global-set-key
	       hooks))

;;C-h f (or M-x describe-function) will show you the bindings for a command.
;;C-h b (or M-x describe-bindings) will show you all bindings.
;;C-h m (M-x describe-mode) is also handy to list bindings by mode.
;;C-h k (M-x describe-key) to show what command is bound to a key.
;;C-h k C-j to find out what command will be run by C-j

