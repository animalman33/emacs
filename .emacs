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
    neotree
    flycheck
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
(setq elpy-rpc-python-command "python3")

;;flycheck
(global-flycheck-mode)
;;remove garbage from buffer
(delight '((abbrev-mode nil abbrev)
	   (ivy-mode nil ivy)
	   (copany-mode nil company)
	   (iront-mode nil irony)
	   (yas-minor-mode nil yasnippter)))

;;show matching delimters
(show-paren-mode)

;;add matching closing delimiter
(electric-pair-mode)

;;make trailing white space visiable for trimming
(setq-default show-trailing-whitespace t)

;;set line numbers to be shown
(global-linum-mode t)

;;custom keybinding
(global-set-key (kbd "M-s") 'shell)
(global-set-key (kbd "M-g") 'gdb)
(global-set-key (kbd "M-t") 'neotree-show)
(global-set-key (kbd "C-l") 'goto-line)
