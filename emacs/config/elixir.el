; -*- mode: Lisp;-*-
(add-hook 'elixir-mode-hook 'alchemist-mode)
(add-hook 'elixir-mode-hook 'company-mode)
(add-hook 'elixir-mode-hook 'smartparens-strict-mode)
(eval-after-load 'elixir-mode-hook '(require 'smartparens-elixir))

(sp-with-modes '(elixir-mode)
  (sp-local-pair "fn" "end"
         :when '(("SPC" "RET"))
         :actions '(insert navigate))
  (sp-local-pair "do" "end"
         :when '(("SPC" "RET"))
         :post-handlers '(sp-ruby-def-post-handler)
         :actions '(insert navigate)))

;; Run tests on save
(setq alchemist-hooks-test-on-save t)
;; Run compile on save
(setq alchemist-hooks-compile-on-save t)

