;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Zamachi"
      user-mail-address "dstefa.dimitrijevic7@gmail.com")

;;fontovi
(setq  doom-font(font-spec :family "Fira Code" :height 220)
       doom-variable-pitch-font(font-spec :family "Cantarell" :height 130))

;;doom theme
(setq doom-theme 'doom-outrun-electric)

(setq display-line-numbers-type t)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; (use-package! general
;;   :config
;;   (general-create-definer zama/leader-keys
;;     :keymaps '(normal visual emacs)
;;     :global-prefix "SPC z")

;;   (zama/leader-keys
;;     "t"  '(:ignore t :which-key "toggles")
;;     "tt" '(counsel-load-theme :which-key "choose theme")))

;;koristi ivy package, koji ima bolji autocomplete za meta- funkcional.(medju ostalim funkc.)

        ;; (use-package! ivy
        ;;   :diminish
        ;;   :bind (("C-s" . swiper)
        ;;          :map ivy-minibuffer-map
        ;;          ("TAB" . ivy-alt-done)
        ;;          ("C-f" . ivy-alt-done)
        ;;          ("C-l" . ivy-alt-done)
        ;;          ("C-j" . ivy-next-line)
        ;;          ("C-k" . ivy-previous-line)
        ;;          :map ivy-switch-buffer-map
        ;;          ("C-k" . ivy-previous-line)
        ;;          ("C-l" . ivy-done)
        ;;          ("C-d" . ivy-switch-buffer-kill)
        ;;          :map ivy-reverse-i-search-map
        ;;          ("C-k" . ivy-previous-line)
        ;;          ("C-d" . ivy-reverse-i-search-kill))
        ;;   :config
        ;;   (ivy-mode 1))
        ;;obogacuje ivy packet sa opisom funkcionalnosti i keybindovima(ako ih imaju)
        ;; (use-package! ivy-rich
        ;;   :after ivy
        ;;   :init
        ;;   (ivy-rich-mode 1))

;;         counsel paket, koji koristi ivy rich, da dodatno obogati meta-pretrage, C-x C-f i dr.
        (use-package! counsel
          :after ivy-rich
          :config
          (counsel-mode 1))

;; (use-package! hydra
;;   :defer t)

;; (defhydra hydra-text-scale (:timeout 4)
;;   "scale text"
;;   ("j" text-scale-increase "in")
;;   ("k" text-scale-decrease "out")
;;   ("f" nil "finished" :exit t))

;; (zama/leader-keys
;;   "ts" '(hydra-text-scale/body :which-key "scale text"))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package! org
  :commands (org-capture)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers t)
  (efs/org-font-setup))

(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; (with-eval-after-load 'org
    ;;   (require 'org-tempo)

    ;;   (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    ;;   (add-to-list 'org-structure-template-alist '("py" . "src python"))
    ;;   (add-to-list 'org-structure-template-alist '("lua" . "src lua"))

    ;;   )

(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("lua" . "src lua"))
  )

(add-hook! lsp-mode
  (defun breadcrumb-setup ()
           (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
           (lsp-headerline-breadcrumb-mode))
    )

;; (require 'dap-node)
;; (dap-node-setup);; Automatically installs Node debug adapter if needed

;; Sa "C-c l d" otvori se dap-hydra prozor za lakse debagovanje
;; (general-define-key
;;   :keymaps 'lsp-mode-map
;;   :prefix lsp-keymap-prefix
;;   "d" '(dap-hydra t :wk "debugger"))

;; (require 'dap-cpptools)
;; (add-hook 'c++-mode-hook 'lsp)

;;projectile project interaction library for emacs. Offers functionalities for projects

(use-package! counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package! devdocs
  :commands(devdocs-install devdocs-search devdocs-lookup))

;;(add-hook 'python-mode-hook
;;          (lambda () (setq-local devdocs-current-docs '("python~3.9"))))

(if (eq system-type 'windows-nt )
    (use-package! powershell
      :commands shell
      :config
      ;; Change default compile command for powershell
      (add-hook 'powershell-mode-hook
                (lambda ()
                  (set (make-local-variable 'compile-command)
                       (format "powershell.exe -NoLogo -NonInteractive -Command \"& '%s'\"" ))))))

(use-package! dired
  :commands(dired dired-jump)
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package! dired-single
  :commands (dired dired-jump))

(use-package! dired-open
  :commands (dired dired-jump)
  :config
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

;; (setq gc-cons-treshold (* 2 1000 1000))
