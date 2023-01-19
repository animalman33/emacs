(require 'org)


  ;; setup package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; refreshes package list
(unless package-archive-contents
  (package-refresh-contents))

;; make sure use-package is installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(defun emacsFile (file)
  (expand-file-name file user-emacs-directory)
  )

(defun getElisp ()
 (org-babel-tangle-file
  (emacsFile "settings.org"))
)

(defun comp ()
  (load-file (native-compile
	      (emacsFile "settings.el" )
	      (emacsFile "settings.eln")
	      )
	     )
  )

(defun compCheck ()
(unless (file-exists-p (emacsFile "settings.eln")) (comp))
(when (file-newer-than-file-p
       (emacsFile "settings.el")
       (emacsFile "settings.eln"))
  (comp))
)

(unless
    (file-exists-p
     (emacsFile "settings.el"))
  (getElisp)
  )

(when (file-newer-than-file-p
       (emacsFile "settings.org")
       (emacsFile "settings.el"))
       (getElisp))

(when (native-comp-available-p) (compCheck))
(when (native-comp-available-p) (load-file
				 (emacsFile "settings.eln")
				 )
      )

(unless (native-comp-available-p) (load-file
				 (emacsFile "settings.el")))
