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

;; Required to be used with neotree
(require 'all-the-icons)

;; Use neotree and set toggle shortcut
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; Every time when the neotree window is opened, let it find current
;; file and jump to node.
(setq neo-smart-open t)

;; Integrate neotree with projectile
(setq projectile-switch-project-action 'neotree-projectile-action)

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

;; Disable auto save files
(setq auto-save-default nil)

;; Manage Emacs backup files
(setq backup-directory-alist `(("." . "~/.emacs_backups")))

(setq backup-by-copying t)

(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Show line numbers
(global-linum-mode t)
(setq linum-format " %d  ")

;; Default font
(set-frame-font "Inconsolata 19" nil t)

;; Use spaces to indent function
(defun soft-tabs ()
  (interactive)
  (setq-default indent-tabs-mode nil)
)

;; Use TABs to indent function
(defun hard-tabs ()
  (interactive)
  (setq-default c-basic-offset 4
				tab-width 4
                indent-tabs-mode t)
)

;; Default to soft-tabs
(soft-tabs)

(setq highlight-indentation-mode t)
;; (set-face-background 'highlight-indentation-face "#141414")

;; -------------------------------------
;; Highlight Indentation Mode - BEGIN
;; -------------------------------------
;; (add-hook 'prog-mode-hook
;;   (lambda ()
;;     (highlight-indentation-mode t)))

;; (set-face-background 'highlight-indentation-face "#141414")
;; -------------------------------------
;; Highlight Indentation Mode - END
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

;; -------------------------------------
;; Blackfy and Whitefy - END
;; -------------------------------------

;; -----------------------------
;; Column at line 80' - BEGIN
;; -----------------------------

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

;; -----------------------------
;; Column at line 80' - END
;; ----------------------------

;; -----------------------------
;; Start diff-hl-mode - BEGIN
;; ----------------------------

(add-hook 'prog-mode-hook (lambda ()
  (diff-hl-mode 1)
))

(add-hook 'text-mode-hook (lambda ()
  (diff-hl-mode 1)
))

(add-hook 'dired-mode-hook (lambda ()
  (diff-hl-dired-mode 1)
))

;; -----------------------------
;; Start diff-hl-mode - END
;; ----------------------------

;; Enables Projectile
;; (projectile-mode)

(require 'projectile)
(projectile-global-mode +1)
(setq projectile-enable-caching t)
;; (global-set-key (kbd "C-c p .") 'helm-projectile-find-file-dwim)

;; Set whitefy() as main theme script
(whitefy)

;; custom-set-variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("e068203104e27ac7eeff924521112bfcd953a655269a8da660ebc150c97d0db8" default)))
 '(initial-buffer-choice "~/.emacs_welcome")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (helm-ag protobuf-mode dockerfile-mode rust-mode exec-path-from-shell vmd-mode flatui-theme all-the-icons neotree elixir-mode helm-projectile projectile highlight-indentation blank-mode yaml-mode diff-hl markdown-mode fill-column-indicator highlight-indent-guides hl-anything highlight-chars color-theme-sanityinc-tomorrow)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
