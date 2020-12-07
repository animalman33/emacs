
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;setup package manger
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)
;;set cusomization file
(setq custom-file "~/.emacs-custom.el")
(load custom-file)

;;ivy mode
(ivy-mode 1)

;;disable ivy tilde mode
(setq ivy-magic-tilde nil)


;;yassnippet
(yas-global-mode 1)

;;remove garbage from buffer
(delight '((abbrev-mode nil abbrev)
	   (ivy-mode nil ivy)
	   (company-mode nil company)
	   (iront-mode nil irony)
	   (yas-minor-mode nil yasnippter)))

;;show matching delimters
(show-paren-mode)

;;add matching closing delimiter
(electric-pair-mode)

;; set thing up for UB CSE
(add-hook 'c-mode-hook 'ub-cse-c-mode)
(add-hook 'c++-mode-hook 'ub-cse-c-mode)

(defun ub-cse-prog-mode ()
  (if (boundp 'display-line-number-mode)
      (display-line-number-mode)
    (linum-mode 1))
;;make traling white space visiable for trimming
  (setq show-trailing-whitespace 1))

;;call function in prog mode
(add-hook 'prog-mode-hook 'ub-cse-prog-mode)

;;add keybindings
(global-set-key (kbd "M-s") 'shell)
(global-set-key (kbd "M-g") 'gdb)
