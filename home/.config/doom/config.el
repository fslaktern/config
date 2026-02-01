;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 16))

(setq doom-theme 'doom-moonlight)
(setq display-line-numbers-type nil)
(setq doom-modeline-mode nil)
(setq initial-frame-alist nil)
(setq default-frame-alist nil)
(setq shell-file-name (executable-find "bash"))

(add-to-list 'default-frame-alist '(undecorated . t))
(set-frame-parameter nil 'undecorated t)
(scroll-bar-mode -1)

(map! "C-'" #'comment-dwim
      "M-SPC" #'er/expand-region
      "M-'" #'uncomment-region
      "M-f" #'forward-same-syntax
      "TAB" #'indent-region
      "C-," #'undo
      "C-." #'undo-redo)

(ido-mode t)
