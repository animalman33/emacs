
;;Fix annoying stuff
;;stop init screen
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

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

;; move files around
;; save all cache stuff into .cache
(setq user-emacs-directory (expand-file-name "~/.cache/emacs"))

   ;; keep emacs clean
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

(make-directory (expand-file-name "tmp/auto-saves" user-emacs-directory) t)

(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
   auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))
(setq create-lockfiles nil)

(unless (file-exists-p (expand-file-name "emacs-custom.el" user-emacs-directory))
  (write-region "" nil (expand-file-name "emacs-custom.el" user-emacs-directory)))

;;set custom file
(setq custom-file (expand-file-name "emacs-custom.el" user-emacs-directory))
(load custom-file)
;; Fonts
;;font
(set-face-attribute 'default nil :font "FiraCode NFM" :height 140)
;;useful settings

;;show matching delimters
(show-paren-mode)

;;add matching closing delimiter
(electric-pair-mode)

;;make trailing white space visiable for trimming
(setq-default show-trailing-whitespace t)

;;set line numbers to be shown
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Themes
;;set theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-acario-dark t)
  )
;;Evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1)
  )

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode))

(use-package evil-snipe
  :ensure t
  :config
  (require 'evil-snipe)
  (evil-snipe-override-mode 1)
  (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)
  )

(use-package undo-tree
  :ensure t
  :after evil
  :config
  (defvar undo-tree-history-directory (concat user-emacs-directory "undo/") "Undo tree history directory")
  (unless (file-exists-p undo-tree-history-directory)
    (make-directory undo-tree-history-directory t))
  (setq undo-tree-history-directory-alist `(("." . ,undo-tree-history-directory)))

  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1)
  )

;; Random

(use-package general
  :ensure t
  :init
  (general-evil-setup)
  )
  ;; Replace 'hydra-space/body with your leader function.


(use-package avy
  :ensure t
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "jj" 'avy-goto-char)
  )

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '(
			  (recents . 5)
			  (projects . 5)
			  (agenda . 5)
			  )
	)
  (setq projectile-switch-project-action #'projectile-dired)
  ;; (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (setq dashboard-set-init-info t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)

  )
(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  )

(use-package page-break-lines
  :ensure t
  :init
  (global-page-break-lines-mode)
  )

;; Vertico and projectile
(use-package vertico
  :ensure t
  :init (vertico-mode)
  :bind (:map vertico-map
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)
	      )
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "ff" 'find-file
   )
  )

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle)
	      )
  :init (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :ensure t
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "fw" 'consult-ripgrep)
  )

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config (setq which-key-idle-delay 1)
  )

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/projects/" "~/school/"))
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "pp" 'projectile-switch-project)
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "tp" 'projectile-test-project)
  )

;;Development tools
(use-package flycheck
  :ensure t
  )
(use-package company
  :ensure t
  :after lsp-mode
  :hook ('after-init-hook 'global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  )

(use-package magit
  :ensure t
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "mg" 'magit
   )
  )

(use-package tree-sitter
  :ensure t
  )

(use-package tree-sitter-langs
  :ensure t
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )

;; get the correct path
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (daemonp)
    (exec-path-from-shell-initialize))
  )

;; Snippets
(use-package yasnippet
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  )

(use-package yasnippet-snippets
  :ensure t)
;; LSP
(use-package lsp-mode
  :ensure t
  :hook (
	 (prog-mode-hook . lsp)
	 (prog-mode . lsp-deferred)
	 )
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "lf" 'lsp-format-buffer)

  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "ca" 'lsp-execute-code-action)
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "rn" 'lsp-rename)
  (setq lsp-warn-no-matched-clients nil)
  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  )

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)


(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))
		     )
  )

;; Rust
(use-package rust-mode
  :ensure t
  :config
  )

;; Golang
(use-package go-mode
  :ensure t)

;; Docker
(use-package dockerfile-mode
  :ensure t)

(use-package docker
  :ensure t
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "dc" 'docker
   )
  )

(use-package docker-tramp
  :ensure t)

;; Python
(use-package poetry
  :ensure t
  )

;; Terminal
(use-package vterm-toggle
  :ensure t
  :config
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "tt" 'vterm-toggle-cd)
  )
(use-package vterm
  :ensure t
  )

(use-package tuareg
  :ensure t)

(use-package lsp-java
  :ensure t
  )

(use-package treemacs
  :ensure t
  :config
  (setq treemacs-width 25))

(use-package treemacs-evil
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t
  )

;; Org mode
(require 'epa-file)
(epa-file-enable)
(setq epg-pinentry-mode 'loopback)

;; ANSI color in compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Some key bindings

(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
(global-set-key [backtab] 'auto-complete)
;; OCaml configuration
;;  - better error and backtrace matching

(defun set-ocaml-error-regexp ()
  (set
   'compilation-error-regexp-alist
   (list '("[Ff]ile \\(\"\\(.*?\\)\", line \\(-?[0-9]+\\)\\(, characters \\(-?[0-9]+\\)-\\([0-9]+\\)\\)?\\)\\(:\n\\(\\(Warning .*?\\)\\|\\(Error\\)\\):\\)?"
    2 3 (5 . 6) (9 . 11) 1 (8 compilation-message-face)))))

(add-hook 'tuareg-mode-hook 'set-ocaml-error-regexp)
(add-hook 'caml-mode-hook 'set-ocaml-error-regexp)
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup   (expand-file-name "~/.config/emacs/opam-user-setup.el"))
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
;; ANSI color in compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Some key bindings

(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
(global-set-key [backtab] 'auto-complete)

