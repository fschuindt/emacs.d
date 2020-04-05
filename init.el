;; Disable alarm bell
(setq ring-bell-function 'ignore)

;; MELPA Setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Start exec-path-from shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Start Wakatime
(global-wakatime-mode)

;; Config auto-complete
(ac-config-default)

;; Support Brazilian ABNT-2 keyboard layout
(require 'iso-transl)

;; Splash Image
(setq fancy-splash-image "~/.emacs.d/gnu_splash.png")

;; yasnippet
(yas-global-mode)

;; use-package
(eval-when-compile
  (require 'use-package))

;; Company LSP
(require 'company-lsp)
(push 'company-lsp company-backends)

;; Use ls-lisp instead ot the system's ls.
;; Sort directories to be shown first in Dired mode.
(require 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-use-insert-directory-program nil)

;; Require vmd-mode and set its key
(require 'vmd-mode)
(global-set-key [f9] 'vmd-mode)

;; Disable UTF-8 file tags
(setq ruby-insert-encoding-magic-comment nil)

;; Kill all buffers fuction
(defun buffer-reset ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;; Disable auto save files
(setq auto-save-default nil)

;; Show line numbers
(global-linum-mode t)
(setq linum-format " %d  ")

;; Default font
(set-frame-font "Inconsolata 19" nil t)

;; -------------------------------------
;; TypeScript - BEGIN
;; -------------------------------------

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
;; (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; set 2 spaces instead of TABs.
(setq js-indent-level 2)
(setq typescript-indent-level 2)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         ;; (before-save . tide-format-before-save)
         ))

;; -------------------------------------
;; TypeScript - END
;; -------------------------------------

;; -------------------------------------
;; LSP - BEGIN
;; -------------------------------------

(use-package lsp-mode
    :commands lsp
    :ensure t
    :diminish lsp-mode
    :hook
    (elixir-mode . lsp)
    (dart-mode . lsp)
    :init
    (add-to-list 'exec-path "/home/fschuindt/apps/clones/elixir-ls/rel"))

(defvar lsp-elixir--config-options (make-hash-table))
(puthash "dialyzerEnabled" :json-false lsp-elixir--config-options)
(add-hook 'lsp-after-initialize-hook
          (lambda ()
            (lsp--set-configuration `(:elixirLS, lsp-elixir--config-options))))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

;; To use debugger
(use-package dap-mode)

;; -------------------------------------
;; LSP - END
;; -------------------------------------

;; -------------------------------------
;; Backup Files - BEGIN
;; -------------------------------------

(setq backup-directory-alist `(("." . "~/.emacs_backups")))

(setq backup-by-copying t)

(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; -------------------------------------
;; Backup Files - END
;; -------------------------------------

;; -------------------------------------
;; Indent - BEGIN
;; -------------------------------------

;; Use TABs for C
(setq-default c-basic-offset 4
			  tab-width 4
              indent-tabs-mode t)

;; Use spaces to indent function
(defun soft-tabs ()
  (interactive)
  (setq-default indent-tabs-mode nil)
)

;; Default to soft-tabs
(soft-tabs)

(setq highlight-indentation-mode t)

;; 2 spaces for CSS
(setq css-indent-offset 2)

;; 2 spaces for JS
(setq js-indent-level 2)

;; -------------------------------------
;; Indent - END
;; -------------------------------------

;; -------------------------------------
;; Show Invisibles - BEGIN
;; -------------------------------------

(setq whitespace-style '(newline-mark tab-mark))
;; space-mark to show all spaces

(whitespace-mode t)

(add-hook 'before-save-hook 'whitespace-cleanup)

(add-hook 'prog-mode-hook
  (lambda ()
    (whitespace-mode t)))

(add-hook 'text-mode-hook
  (lambda ()
    (whitespace-mode t)))

(setq whitespace-display-mappings
  '((newline-mark 10 [172 10])
    (indentation 32 [183] [46])))

;; -------------------------------------
;; Show Invisibles - END
;; -------------------------------------

;; -------------------------------------
;; Blackfy and Whitefy - BEGIN
;; -------------------------------------

(defun whitefy ()
  (interactive)
  (load-theme 'flatui t)
  (set-face-attribute 'mode-line-buffer-id nil :foreground "white")

  (with-eval-after-load "dired"
    (set-face-foreground 'dired-directory "dark magenta"))
)

(defun blackfy ()
  ;; Allow function to be used with M-x
  (interactive)

  ;; Use Tomorrow Night theme
  (load-theme 'sanityinc-tomorrow-bright t)

  ;; Line number colors
  (set-face-foreground 'linum "#444444")
  (set-face-background 'linum "#161616")

  ;; Foreground/Background color
  (set-background-color "#1F1E1E")
  (set-foreground-color "#878787")

  ;; Column at line 80' color
  (setq fci-rule-color "#444444")
)

;; Set whitefy() as main theme script
(whitefy)

;; -------------------------------------
;; Blackfy and Whitefy - END
;; -------------------------------------

;; -------------------------------------
;; Column at line 80' - BEGIN
;; -------------------------------------

(setq fci-rule-width 1)

(defun sanityinc/fci-enabled-p () (symbol-value 'fci-mode))

(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
        (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and sanityinc/fci-mode-suppressed
    (null popup-instances))
  (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))

(add-hook 'prog-mode-hook (lambda ()
  (fci-mode 1)
))

;; -------------------------------------
;; Column at line 80' - END
;; -------------------------------------

;; -------------------------------------
;; Start diff-hl-mode - BEGIN
;; -------------------------------------

(add-hook 'prog-mode-hook (lambda ()
  (diff-hl-mode 1)
))

(add-hook 'text-mode-hook (lambda ()
  (diff-hl-mode 1)
))

;; Also set dired-hide-details as default mode.
(add-hook 'dired-mode-hook (lambda ()
  (diff-hl-dired-mode 1)
  (dired-hide-details-mode 1)
))

;; -------------------------------------
;; Start diff-hl-mode - END
;; -------------------------------------

;; -------------------------------------
;; Helm and Projectile - BEGIN
;; -------------------------------------

;; Enables Projectile
(require 'projectile)
(projectile-global-mode +1)
(setq projectile-enable-caching t)

;; Helm/Projectile custom shortcuts
(global-set-key (kbd "M-p") 'projectile-add-known-project)
(global-set-key (kbd "M-n") 'helm-projectile-ag)

;; Open dired-mode when switching projects
(setq projectile-switch-project-action 'projectile-dired)

;; -------------------------------------
;; Helm and Projectile - END
;; -------------------------------------

;; custom-set-variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("e068203104e27ac7eeff924521112bfcd953a655269a8da660ebc150c97d0db8" default)))
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (company tide typescript-mode langtool gnuplot-mode yasnippet use-package dap-mode company-lsp lsp-ui flycheck helm-lsp lsp-mode flutter dart-mode terraform-mode json-reformatter-jq nginx-mode ac-alchemist ac-c-headers ac-clang ac-html ac-html-bootstrap ac-php alchemist php-mode auto-complete wakatime-mode multiple-cursors toml-mode feature-mode writeroom-mode helm-ag protobuf-mode dockerfile-mode rust-mode exec-path-from-shell vmd-mode flatui-theme elixir-mode helm-projectile projectile highlight-indentation blank-mode yaml-mode diff-hl markdown-mode fill-column-indicator highlight-indent-guides hl-anything highlight-chars color-theme-sanityinc-tomorrow)))
 '(tool-bar-mode nil)
 '(wakatime-cli-path "/usr/bin/wakatime")
 '(wakatime-python-bin nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
