;;; init.el --- Emacs initialization file.

;; Author: fschuindt
;; Maintainer: fschuindt
;; Version: 0.1.0
;; Package-Requires: vmd, wakatime-cli, the silver searcher, Inconsolata font
;; Homepage: https://github.com/fschuindt/.emacs.d
;; Keywords: Emacs, dotfiles


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; Yes, I needed a comment here.

;;; Code:

;;; Straight.el
(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; MELPA Setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Stops the buzz-like noise that Emacs emits by default.
(setq ring-bell-function 'ignore)

;; Starts exec-path-from shell.
;; Ensures that Emacs will inherit environment variables from host
;; OS, so that Shell commands will work.
;; https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Starts Wakatime.
;; Sends time reports to the Wakatime API.
;; Check: https://wakatime.com/
(global-wakatime-mode)

;; Configs auto-complete.
;; Implements auto-completion for Emacs.
;; Check: https://github.com/auto-complete/auto-complete
(ac-config-default)

;; Supports the Brazilian ABNT-2 keyboard layout.
(require 'iso-transl)

;; Starts yasnippet.
;; It allows you to type an abbreviation and automatically expand it
;; into function templates.
;; Check: https://github.com/joaotavora/yasnippet
(yas-global-mode)

;; use-package
;; Allows you to isolate package configuration in your .emacs.
;; Check: https://github.com/jwiegley/use-package
(eval-when-compile
  (require 'use-package))

;; Use ls-lisp instead ot the system's ls.
;; Sorts directories to be shown first in Dired mode.
(require 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-use-insert-directory-program nil)

;; Starts vmd and set its key.
;; Allows you to render Markdown documents inside Emacs.
(require 'vmd-mode)
(global-set-key [f9] 'vmd-mode)

;; Disable UTF-8 file tags from Ruby files.
;; Those are no longer used in modern Ruby.
;; Check: https://mail.gnu.org/archive/html/bug-gnu-emacs/2021-04/msg01564.html
(setq ruby-insert-encoding-magic-comment nil)

;; Close all Emacs buffers.
(defun kill-all-buffers ()
  "This function will kill all the buffers from the current Emacs buffer list."
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(global-set-key (kbd "C-c k") 'kill-all-buffers)

;; Disable auto saving files.
;; Let me save the file when I like to.
(setq auto-save-default nil)

;; Show line numbers.
(global-display-line-numbers-mode 1)
(setq linum-format " %d  ")

;; Default font.
(set-frame-font "Inconsolata 19" nil t)

;; Display time within emacs.
(display-time)

;; -------------------------------------
;; web-mode - BEGIN
;; Helps editing HTML, CSS and embeded JS.
;; Check: https://web-mode.org/
;; -------------------------------------

(defun config-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  )

(add-hook 'web-mode-hook  'config-web-mode-hook)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))

;; -------------------------------------
;; web-mode - END
;; -------------------------------------

;; -------------------------------------
;; JavaScript - BEGIN
;; For editing JavaScript.
;; Check: https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html
;; -------------------------------------

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Better imenu.
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(require 'js2-refactor)
(require 'xref-js2)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with
;; xref, so unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; -------------------------------------
;; JavaScript - END
;; -------------------------------------

;; -------------------------------------
;; TypeScript - BEGIN
;; Sets up Tide: TypeScript Interactive Development Environment for
;; Emacs.
;; Check: https://github.com/ananthakumaran/tide
;; -------------------------------------

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

(defun setup-tide-mode ()
  "Set up TypeScript interactive development environment."
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

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; Use rjsx-mode for all .js files
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

;; set 2 spaces instead of TABs.
(setq js-indent-level 2)
(setq typescript-indent-level 2)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         ))

;; -------------------------------------
;; TypeScript - END
;; -------------------------------------

;; -------------------------------------
;; Copilot - BEGIN
;; -------------------------------------
(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t)

(add-hook 'prog-mode-hook 'copilot-mode)

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; -------------------------------------
;; Copilot - END
;; -------------------------------------

;; -------------------------------------
;; LSP - BEGIN
;; Sets up lsp-mode, a Language Server Protocol Emacs implementation.
;; Check: https://github.com/emacs-lsp/lsp-mode
;; -------------------------------------

(defvar lsp-elixir--config-options (make-hash-table))

(use-package lsp-mode
    :commands lsp
    :ensure t
    :diminish lsp-mode
    :hook
    (elixir-mode . lsp)
    (dart-mode . lsp)
    (c++-mode . lsp)
    (c-mode . lsp)
    :init
    (add-to-list 'exec-path "/home/fschuindt/apps/clones/elixir-ls/rel"))

(add-hook 'lsp-after-initialize-hook
          (lambda ()
            (lsp--set-configuration `(:elixirLS, lsp-elixir--config-options))))

(puthash "dialyzerEnabled" :json-false lsp-elixir--config-options)
(puthash "fetchDeps" :json-false lsp-elixir--config-options)

(setq lsp-file-watch-threshold 2000)

(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(global-set-key (kbd "M-q") 'lsp-find-definition)
(global-set-key (kbd "M-s") 'lsp-find-references)

;; To use debugger.
(use-package dap-mode)

;; PlatformIO
(require 'platformio-mode)

;; This is a C/C++/Objective-C LSP.
(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

;; PlatformIO
(add-hook 'flycheck-mode-hook 'flycheck-irony-setup)

;; PlatformIO
;; Enable ccls for all c++ files, and platformio-mode only
;; when needed (platformio.ini present in project root).
(add-hook 'c++-mode-hook (lambda ()
                           (lsp-deferred)
                           (platformio-conditionally-enable)))

;; -------------------------------------
;; LSP - END
;; -------------------------------------

;; -------------------------------------
;; Rust - BEGIN
;; A set of configurations for editing Rust.
;; -------------------------------------

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config (setq company-tooltip-align-annotations t)
          (setq company-minimum-prefix-length 1))

;; (use-package lsp-ui)
(use-package toml-mode)
;; (use-package rust-mode
;;   :hook (rust-mode . lsp))

;; Add keybindings for interacting with Cargo
(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; -------------------------------------
;; Rust - END
;; -------------------------------------

;; -------------------------------------
;; Backup Files - BEGIN
;; Keeps all the Emacs backup files like foo.txt~ at their own
;; system directory to avoid messing with Git.
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
;; Code indentation settings.
;; -------------------------------------

;; Use TABs for C.
(setq-default c-basic-offset 4
			  tab-width 4
              indent-tabs-mode t)

;; Use spaces to indent function
(defun soft-tabs ()
  "It will instruct Emacs to use spaces instead of tabs to indent functions."
  (interactive)
  (setq-default indent-tabs-mode nil)
)

;; Defaults to soft-tabs.
(soft-tabs)

(setq highlight-indentation-mode t)

;; 2 spaces for CSS
(setq css-indent-offset 2)

;; -------------------------------------
;; Indent - END
;; -------------------------------------

;; -------------------------------------
;; Show Invisibles - BEGIN
;; Adds all the invisibles I like to work with.
;; -------------------------------------

(setq whitespace-style '(newline-mark tab-mark))

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
;; The light theme is default, but if ever needed this provides ways
;; for switching between light and dark themes.
;; -------------------------------------

(defun whitefy ()
  "Set Emacs to a light color theme."
  (interactive)
  (load-theme 'flatui t)
  (set-face-attribute 'mode-line-buffer-id nil :foreground "white")

  (with-eval-after-load "dired"
    (set-face-foreground 'dired-directory "dark magenta"))
)

(defun blackfy ()
  "Set Emacs to a dark color theme."
  (interactive)

  ;; Use Tomorrow Night theme.
  (load-theme 'sanityinc-tomorrow-bright t)

  ;; Set line number colors.
  (set-face-foreground 'linum "#444444")
  (set-face-background 'linum "#161616")

  ;; Set foreground and background colors.
  (set-background-color "#1F1E1E")
  (set-foreground-color "#878787")

  ;; Set the line at the column 80' color.
  (setq fci-rule-color "#444444")
)

;; Set the light theme as default.
(whitefy)

;; -------------------------------------
;; Blackfy and Whitefy - END
;; -------------------------------------

;; -------------------------------------
;; Line at the column 80' - BEGIN
;; This will show a vertical line at the column 80'.
;; -------------------------------------

(setq fci-rule-width 1)

(defun sanityinc/fci-enabled-p ()
  "Initialize fci-mode."
  (symbol-value 'fci-mode))

(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible."
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
        (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed."
  (when (and sanityinc/fci-mode-suppressed
    (null popup-instances))
  (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))

(add-hook 'prog-mode-hook (lambda ()
  (fci-mode 1)
))

;; -------------------------------------
;; Line at the column 80' - END
;; -------------------------------------

;; -------------------------------------
;; Start diff-hl-mode - BEGIN
;; Shows Git status within files and the Dired mode.
;; Check: https://github.com/dgutov/diff-hl
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
;; Projectile, Ido and Helm - BEGIN
;; Amazing tools for interacting with the concept of projects.
;; Projectile implements the concept of projects.
;; Ido helps with auto-completion, searchig projects and files.
;; I use Helm for the project search feature with the helm-ag.
;; Check: https://github.com/bbatsov/projectile
;; Check: https://github.com/emacs-helm/helm
;; -------------------------------------

(use-package helm)

(setq enable-recursive-minibuffers t)

(require 'projectile)
(projectile-mode +1)
(setq projectile-enable-caching t)

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(global-set-key (kbd "M-p") 'projectile-add-known-project)
(global-set-key (kbd "M-n") 'helm-projectile-ag)

;; Open dired-mode when switching projects.
(setq projectile-switch-project-action 'projectile-dired)

;; Ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-show-dot-for-dired t)
(ido-mode 1)

(setq projectile-completion-system 'ido)

;; Use Ido to find/create files and avoid issues with autocomplete.
(global-set-key (kbd "C-x C-f") 'ido-find-file)

;; Ido insists to open an existing file when I want to create a new one.
;; This will disable this behavior.
;; See: https://www.reddit.com/r/emacs/comments/y4tgp/comment/c5sec0d/
(setq ido-auto-merge-work-directories-length -1)

;; -------------------------------------
;; Projectile, Ido and Helm - END
;; -------------------------------------

;; custom-set-variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e068203104e27ac7eeff924521112bfcd953a655269a8da660ebc150c97d0db8" default))
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(editorconfig dash s lsp-mode magit helm-company flycheck-irony platformio-mode ac-helm elixir-mode haskell-mode lsp-ui lua-mode lsp-docker wakatime-mode gdscript-mode cmake-mode flycheck-rust xref-js2 js2-refactor web-mode erlang rjsx-mode tide typescript-mode langtool gnuplot-mode use-package dap-mode company-lsp flycheck helm-lsp flutter dart-mode terraform-mode json-reformatter-jq nginx-mode ac-alchemist ac-c-headers ac-clang ac-html ac-html-bootstrap ac-php alchemist php-mode auto-complete multiple-cursors toml-mode feature-mode writeroom-mode helm-ag protobuf-mode dockerfile-mode rust-mode exec-path-from-shell vmd-mode flatui-theme helm-projectile projectile highlight-indentation blank-mode yaml-mode diff-hl markdown-mode fill-column-indicator highlight-indent-guides hl-anything highlight-chars color-theme-sanityinc-tomorrow))
 '(tool-bar-mode nil)
 '(wakatime-cli-path "/usr/bin/wakatime")
 '(wakatime-python-bin nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
