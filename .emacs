;;============================================================
;;== notori0us .emacs                                       ==
;;==== based off github.com/marchtemp/emacsconf             ==
;;============================================================
;; Load modules/modes
;;------------------------------------------------------------

;; ELPA and marmalade
(require 'package)
(add-to-list 'package-archives
            '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(add-to-list 'package-archives
            '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; My custom file
(add-to-list 'load-path "~/.emacs.d")
(load "m-utils.el")

;; evil
(add-to-list 'load-path "~/.emacs.d/plugins/evil")
(require 'evil)
(evil-mode 1) 

(add-to-list 'load-path "~/.emacs.d/plugins/indent-guides")
(load "highlight-indentation.el")
(highlight-indentation-mode)
(set-face-background 'highlight-indentation-face "#e3e3d3")
(set-face-background 'highlight-indentation-current-column-face "#c3b3b3")

;; YASnippet template facility
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas/global-mode 1)

;; My settings
;;------------------------------------------------------------

;; move meta to super
(setq x-meta-keysym 'super)

;; The message is too annoying, start with *scratch* instead
(setq inhibit-startup-message t)

;; hightlight parentheses
(show-paren-mode 1)

;; Indentation
(define-key global-map (kbd "RET") 'newline-and-indent)

;; display line numbers
(global-linum-mode t)

;; make line numbers look nice
(setq linum-format "%d")
(setq linum-format "%4d \u2502")

;;; set the default tab length to 4
(setq default-tab-width 4)

;; set whitespace mode on
(whitespace-mode 1)

;; Bindings
;;------------------------------------------------------------

;; change META key to the super (windows) key
(setq x-super-keysym 'meta)

;; save the current buffer
(define-key evil-normal-state-map (kbd "SPC w") 'save-buffer)

;; window navigation
(global-set-key [C-left] 'windmove-left)         ; ; move to left windnow
(global-set-key [C-right] 'windmove-right)       ; ; move to right window
(global-set-key [C-up] 'windmove-up)             ; ; move to upper window
(global-set-key [C-down] 'windmove-down)         ; ; move to downer window

;; resizing windows
(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)

;; match parenthesis with %
;; defined in m-utils.el
;; (global-set-key "%" 'match-paren) 
(define-key evil-normal-state-map (kbd "%") 'match-paren)

;; Smart semicolon
;; insert-or-append-semi is defined in m-utils.el
;;(define-key evil-insert-state-map (kbd ";") 'insert-or-append-semi)

;; (define-key evil-insert-state-map (kbd ":") 'insert-or-append-colon)

;; gc as toggle comment
(define-key evil-visual-state-map (kbd "gc") 'comment-or-uncomment-region)


;; (setq x-select-enable-clipboard t)
;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;; [ | ] C-x 3
;; (split-window-horizontally)
;; set font to 10
;; (set-face-attribute 'default nil :height 100)
;; start maximized
;; defined in m-utils.el
;; (toggle-fullscreen)

;(tool-bar-mode -1)
(menu-bar-mode -1) 
;(scroll-bar-mode -1)

(load-theme 'wombat t)
(setq frame-title-format "%b - vim")
;; (setq frame-title-format "%b - The Ultimate Text Editor")

;; (setq frame-title-format "%b - Sublime Text 2 Premium User")

;; Copy sr-speedbar.el to your load-path and add to your ~/.emacs
;(require 'sr-speedbar)
;(global-set-key (kbd "s-s") 'sr-speedbar-toggle)
;(sr-speedbar-toggle)
