;;stop init screen
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; save all cache stuff into .cache
(setq user-emacs-directory (expand-file-name "~/.cache/emacs"))

;;font
(set-face-attribute 'default nil :height 140)

;;show matching delimters
(show-paren-mode)

;;add matching closing delimiter
(electric-pair-mode)

;;make trailing white space visiable for trimming
(setq-default show-trailing-whitespace t)

;;set line numbers to be shown
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; keep emacs clean
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

(make-directory (expand-file-name "tmp/auto-saves" user-emacs-directory) t)

(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))


(setq create-lockfiles nil)

;;setup package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
;;set custom file
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)


;;refreshes package list
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

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

;;set theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-acario-dark t)
  )

(use-package ivy
  :ensure t
  :bind (
	 :map ivy-minibuffer-map
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 )
  )

(use-package counsel
  :ensure t
  :bind ("M-x" . counsel-M-x)
  :init
  (general-define-key
  :states '(normal visual)
  :prefix "SPC"
  "ff" 'counsel-find-file)
  )
(use-package counsel-projectile
  :ensure t
  :init
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "pp" 'counsel-projectile-switch-project)
  (general-define-key
   :states '(normal visual)
   :prefix "SPC"
   "fg" 'counsel-projectile-rg)
  )

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config (setq which-key-idle-delay 1)
  )

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

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  )

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/projects/" "~/school/"))
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

  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (setq dashboard-set-init-info t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  )

(use-package page-break-lines
  :ensure t
  :init
  (global-page-break-lines-mode)
  )

(use-package vterm
  :ensure t)

(use-package yasnippet
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  )

(use-package yasnippet-snippets
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook (
	 (c-mode . lsp)
	 (c++-mode . lsp)
	 (rust-mode . lsp)
	 (go-mode-hook . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)
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

  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

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

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
	  (require 'lsp-pyright)
	  (lsp))
	 )
  )

(use-package rust-mode
  :ensure t
  :config
  )

(use-package go-mode
  :ensure t)

(use-package undo-tree
  :ensure t
  :after evil
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1)
  )

;; get the correct path
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (daemonp)
    (exec-path-from-shell-initialize))
  )

