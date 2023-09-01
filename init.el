
;; setup package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))


;; refreshes package list
(unless package-archive-contents
  (package-refresh-contents)) ;; make sure use-package is installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(require 'org)

(org-babel-load-file (expand-file-name "~/.config/emacs/settings.org"))
