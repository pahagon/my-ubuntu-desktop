; -*- mode: Lisp;-*-
;https://www.gnu.org/software/emacs/manual/html_node/tramp/Auto_002dsave-and-Backup.html
;
;Disabling backups can be targeted to just the su and sudo methods
(setq backup-enable-predicate
      (lambda (name)
	(and (normal-backup-enable-predicate name)
	     (not
	      (let ((method (file-remote-p name 'method)))
		(when (stringp method)
		  (member method '("su" "sudo"))))))))

;https://www.emacswiki.org/emacs/BackupDirectory
;Placing all backup files in system temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

