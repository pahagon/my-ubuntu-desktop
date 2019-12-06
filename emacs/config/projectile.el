;Its goal is to provide a nice set of features operating on a project level
;(setq projectile-indexing-method 'native)
(projectile-global-mode)
(setq projectile-file-exists-remote-cache-expire (* 10 60))
;(setq projectile-switch-project-action 'projectile-dired)
(setq projectile-find-dir-includes-top-level t)
