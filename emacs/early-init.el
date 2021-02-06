(menu-bar-mode -1)                             ; No menubar
(setq inhibit-startup-message t)               ; No message at startup
(setq initial-scratch-message "")
(setq visible-bell t)                          ; No beep when reporting errors
(global-hl-line-mode t)                        ; Highlight cursor line
(global-display-line-numbers-mode)
(set-face-background 'hl-line "#333333")
(set-face-foreground 'highlight nil)
(add-to-list 'default-frame-alist '(font . "iosevka")); Change fonts

