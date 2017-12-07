;; Disable alarm bell
(setq ring-bell-function 'ignore)

;; MELPA Setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Manage Emacs backup files
(setq backup-directory-alist `(("." . "~/.emacs_backups")))

(setq backup-by-copying t)

(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Select theme
(load-theme 'sanityinc-tomorrow-bright t)

;; Show line numbers
(global-linum-mode t)
(setq linum-format " %d  ")

;; Line number colors
(set-face-foreground 'linum "#444444")
(set-face-background 'linum "#161616")

;; Set foreground/background color to match with my shell
(set-background-color "#1F1E1E")
(set-foreground-color "#A8A8A8")

;; Default font
(set-frame-font "Inconsolata 19" nil t)

;; -------------------------------------
;; Display New Line Character - BEGIN
;; -------------------------------------

(setq whitespace-style '(face newline-mark spaces space-mark trailing tabs newline tab-mark))
(whitespace-mode t)

(add-hook 'prog-mode-hook
  (lambda ()
    (whitespace-newline-mode t)))

(add-hook 'text-mode-hook
  (lambda ()
    (whitespace-newline-mode t)))

(setq whitespace-display-mappings
  '((newline-mark 10 [172 10])))

(set-face-foreground 'whitespace-newline "#444444")
(set-face-background 'whitespace-newline nil)

(set-face-foreground 'whitespace-space-mark "#444444")
(set-face-background 'whitespace-space-mark nil)

;; -------------------------------------
;; Display New Line Character - END
;; -------------------------------------

;; -------------------------------
;; Display White Spaces - BEGIN
;; -------------------------------

;; -------------------------------
;; Display White Spaces - END
;; -------------------------------

;; -----------------------------
;; Column at line 80' - BEGIN
;; -----------------------------

(setq fci-rule-width 1)
(setq fci-rule-color "#444444")

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
    (blank-mode yaml-mode diff-hl markdown-mode fill-column-indicator highlight-indent-guides hl-anything highlight-chars color-theme-sanityinc-tomorrow)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
