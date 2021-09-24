; -*- mode: Lisp;-*-
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq select-enable-clipboard t)
(load-theme 'zenburn t)
(setq-default truncate-lines t)
(set-frame-font "DejaVu Sans Mono for Powerline:pixelsize=20:antialias=true" nil t)

