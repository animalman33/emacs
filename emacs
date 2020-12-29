;;fix package manager
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;stop init screen
(setq inhibit-startup-screen t)

;;setup package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
;;set custom file
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

;;package list for install
(defvar myPackages
  '(ivy
    yasnippet
    sublime-themes
    ivy-yasnippet
    delight
    elpy
    )
  )
;;function to install packages
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

;;set theme
(load-theme 'spolsky t)

;;ivy mode
(ivy-mode 1)

;;disable ivy tilde mode
(setq ivy-magic-tilde nil)

;;yassnippet
(yas-global-mode 1)

;;elpy
(elpy-enable)

;;remove garbage from buffer
(delight '((abbrev-mode nil abbrev)
	   (ivy-mode nil ivy)
	   (copany-mode nil company)
	   (iront-mode nil irony)
	   (yas-minor-mode nil yasnippter)))

;;set things up for UB CSE

(add-hook 'c-mode-hook 'ub-cse-c-mode)
(add-hook 'c++-mode-hook 'ub-cse-c-mode)

;;show matching delimters
(show-paren-mode)

;;add matching closing delimiter
(electric-pair-mode)

(defun ub-cse-prog-mode ()
  (if (boundp 'display-line-number-mode)
      (display-line-number-mode)
    (linum-mode 1))
  ;;make trailing white space visiable for trimming
  (setq show-trailing-whitespace 1))
;;call function in prog mode
(add-hook 'prog-mode-hook 'ub-cse-prog-mode)

;;custom keybinding
(global-set-key (kbd "M-s") 'shell)
(global-set-key (kbd "M-g") 'gdb)
