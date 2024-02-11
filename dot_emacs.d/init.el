(require 'package)

;; Add melpa package source when using package list
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Load emacs packages and activate them
;; This must come before configurations of installed packages.
;; Don't delete this line.
(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; (load-theme 'solarized t)
(set-terminal-parameter nil 'background-mode 'dark)

(defalias 'yes-or-no-p 'y-or-n-p)
