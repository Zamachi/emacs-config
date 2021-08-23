;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Zamachi"
      user-mail-address "dstefa.dimitrijevic7@gmail.com")

;;fontovi
(setq  doom-font(font-spec :family "Fira Code" :height 220)
       doom-variable-pitch-font(font-spec :family "Cantarell" :height 130))

;;doom theme
(use-package! doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-outrun-electric t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq display-line-numbers-type t)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package! general
  :config
  (general-create-definer zama/leader-keys
    :keymaps '(normal visual emacs)
    :global-prefix "SPC z")

  (zama/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package! solaire-mode)
(add-to-list 'solaire-mode-themes-to-face-swap 'doom-outrun-electric)
(solaire-global-mode 1)

(use-package! which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

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

  (use-package! helpful
    :commands (helpful-callable helpful-variable helpful-command helpful-key)
    :custom
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
    :bind
    ([remap describe-function] . counsel-describe-function)
    ([remap describe-command] . helpful-command)
    ([remap describe-variable] . counsel-describe-variable)
    ([remap describe-key] . helpful-key))

  (use-package! hydra
    :defer t)

  (defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t))

  (zama/leader-keys
    "ts" '(hydra-text-scale/body :which-key "scale text"))

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

(with-eval-after-load 'org
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

    (with-eval-after-load 'org
      (require 'org-tempo)

      (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
      (add-to-list 'org-structure-template-alist '("py" . "src python"))
      (add-to-list 'org-structure-template-alist '("lua" . "src lua"))

      )

  ;; (defun efs/org-babel-tangle-config ()
  ;;   (when (string-equal (buffer-file-name)
  ;;                       (expand-file-name "~/.doom.d/config.org"))
  ;;     ;; Dynamic scoping to the rescue
  ;;     (let ((org-confirm-babel-evaluate nil))
  ;;       (org-babel-tangle))))

  ;; (add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

    (defun efs/lsp-mode-setup ()
      (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
      (lsp-headerline-breadcrumb-mode))

    (use-package! lsp-mode
      :commands(lsp lsp-deferred)
      :hook(lsp-mode . efs/lsp-mode-setup)
      :config
      (lsp-enable-which-key-integration t))

    (use-package! lsp-ui
      :hook(lsp-mode . lsp-ui-mode)
      :custom
      (lsp-ui-doc-position 'bottom))

    (use-package! lsp-treemacs
      :after lsp);;lsp-treemacs menu
    ;;we can also enable the sideline via lsp-ui-sideline-enable and lsp-ui-sideline-show-hover

    (use-package! lsp-ivy
      :after lsp)
    ;;lsp-ivy-workspace-symbol usage

  (use-package! dap-mode
    ;; Uncomment the config below if you want all UI panes to be hidden by default!
    :custom
    (lsp-enable-dap-auto-configure nil)
    :config
    ;; Set up Node debugging
    (require 'dap-node)
    ;; (dap-node-setup);; Automatically installs Node debug adapter if needed
    (dap-ui-mode 1)

    ;; Sa "C-c l d" otvori se dap-hydra prozor za lakse debagovanje
    ;; (general-define-key
    ;;   :keymaps 'lsp-mode-map
    ;;   :prefix lsp-keymap-prefix
    ;;   "d" '(dap-hydra t :wk "debugger"))
    )

  ;; (use-package! typescript-mode
  ;;       :mode "\\.ts\\'"
  ;;     :hook (typescript-mode . lsp-deferred)
  ;;   :config
  ;; (setq typescript-indent-level 2))

  ;; (use-package! lua-mode
  ;;   :mode "\\.lua\\'"
  ;;   :hook (lua-mode . lsp-deferred)
  ;; )

  ;; (use-package! love-minor-mode)

;; (use-package! lsp-pyright
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-pyright)
;;                          (lsp))))

  (require 'dap-cpptools)
  (add-hook 'c++-mode-hook 'lsp)

    (use-package! company
      :after lsp-mode
      :hook(lsp-mode . company-mode)
      ;; :bind (:map company-active-map
      ;;             ("<tab>" . company-complete-selection))
      ;; (:map lsp-mode-map
      ;;       ("<tab>" . company-indent-or-complete-common))
      :custom
      (company-minimum-prefix-length 1)
      (company-idle-delay 0.0))

    (use-package! company-box
      :hook(company-mode . company-box-mode))

  ;;projectile project interaction library for emacs. Offers functionalities for projects
  (use-package! projectile
    :diminish projectile-mode
    :config (projectile-mode)
    :custom ((projectile-completion-system 'ivy))
    :init
    (when (file-directory-p "~/Projects") ;;NOTE: set this path to where you keep git repos
      (setq projectile-project-search-path '("~/Projects"))) ;;NOTE: same for this
    (setq projectile-switch-project-action #'projectile-dired))

  ;; (use-package! counsel-projectile
  ;;   :after projectile
  ;;   :config (counsel-projectile-mode))

  (use-package! magit
    :commands magit-status
    :custom
    (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

  ;; (use-package! forge
  ;;   :after magit);;pruza informacije o nekom repozitorijumu, zahteva autentifikaciju sa GitHubom da bi se koristila. PROCITATI DOKUMENTACIJU

(use-package! rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package! devdocs)

;;(add-hook 'python-mode-hook
;;          (lambda () (setq-local devdocs-current-docs '("python~3.9"))))

  (if (eq system-type 'windows-nt )
      (use-package! powershell
        :config
        ;; Change default compile command for powershell
        (add-hook 'powershell-mode-hook
                  (lambda ()
                    (set (make-local-variable 'compile-command)
                         (format "powershell.exe -NoLogo -NonInteractive -Command \"& '%s'\"" ))))))

  (if (eq system-type 'gnu/linux)
      (use-package! vterm
        :commands vterm
        :config
        (setq term-prompt-regexp "^[^#$%\n]*[#$%>] *")
        ;;(setq vterm-shell "zsh") ;;for custom shell launch
        (setq vterm-max-scrollback 10000))
    )

  (defun efs/configure-eshell ()
    ;; Save command history when commands are entered
    (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

    ;; Truncate buffer for performance
    (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

    ;; Bind some useful keys for evil-mode
    (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
    (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
    (evil-normalize-keymaps)

    (setq eshell-history-size         10000
          eshell-buffer-maximum-lines 10000
          eshell-hist-ignoredups t
          eshell-scroll-to-bottom-on-input t))
(if (eq system-type 'windows-nt )
    (use-package! eshell-git-prompt
      :after eshell)

    (use-package! eshell
      :hook (eshell-first-time-mode . efs/configure-eshell)
      :config

    (with-eval-after-load 'esh-opt
      (setq eshell-destroy-buffer-when-process-dies t)
      (setq eshell-visual-commands '("htop" "zsh" "vim")))

    (eshell-git-prompt-use-theme 'powerline)))

  (use-package! dired
    :commands(dired dired-jump)
    :custom ((dired-listing-switches "-agho --group-directories-first"))
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer))

  (use-package! dired-single
    :commands (dired dired-jump))

  (use-package! all-the-icons-dired
    :hook (dired-mode . all-the-icons-dired-mode))

(use-package! dired-open
  :commands (dired dired-jump)
  :config
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

;; (setq gc-cons-treshold (* 2 1000 1000))
