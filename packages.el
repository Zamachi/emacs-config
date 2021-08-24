;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! org-bullets)
(package! visual-fill-column)
(package! devdocs)
(if (eq system-type 'windows-nt )
    (package! powershell)
)
