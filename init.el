(setq gc-cons-treshold (* 50 1000 1000))


(defun zamachi/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'zamachi/display-startup-time)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "23:00"))

;;ukljucuje brojeve redova/kolona za svaki deo koda
  (column-number-mode)
  (global-display-line-numbers-mode t)
;;iskljucuje brojeve redova za date mode-ove
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  shell-mode-hook
                  treemacs-mode
                  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))
  ;;adds a function to a "hook" variable



    (custom-set-variables
     ;; custom-set-variables was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(ansi-color-faces-vector
       [default default default italic underline success warning error])
     '(cua-mode t nil (cua-base))
     '(custom-safe-themes
       '("e6a2832325900ae153fd88db2111afac2e20e85278368f76f36da1f4d5a8151e" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "da53441eb1a2a6c50217ee685a850c259e9974a8fa60e899d393040b4b8cc922" default))
     '(debug-on-error t)
     '(menu-bar-mode nil)
     '(package-selected-packages
       '(visual-fill-column org-bullets forge evil-magit counsel-projectile projectile solaire-mode helpful counsel which-key doom-modeline ivy use-package doom-themes))
     '(scroll-bar-mode nil)
     '(tool-bar-mode nil)
     '(tooltip-mode nil))

(set-face-attribute 'default nil :font "Fira Code Retina" :height 120)
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 120)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 120 :weight 'regular)

(use-package general
  :config
  (general-create-definer zama/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (zama/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t);;uvek drzi ukljuceno(RECOMMENDED ?)
  (setq evil-want-keybinding nil)
  ;;(setq evil-want-C-u-scroll t);;ovo sluzi kao default Vim keybind za scrollovanje gore
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1);;ukljucuje evil mode globalno (?)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;;doom-theme
(use-package doom-themes
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

;;AKO SE IKONICE NE VIDE, URADI M-x all-the-icons-install-fonts
(use-package all-the-icons)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom(
	  (doom-modeline-height 15)
	  (doom-modeline-icon t)
	  ))

(use-package solaire-mode)
(add-to-list 'solaire-mode-themes-to-face-swap 'doom-outrun-electric)
(solaire-global-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

;;koristi ivy package, koji ima bolji autocomplete za meta- funkcional.(medju ostalim funkc.)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-f" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
;;obogacuje ivy packet sa opisom funkcionalnosti i keybindovima(ako ih imaju)
(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

;;counsel paket, koji koristi ivy rich, da dodatno obogati meta-pretrage, C-x C-f i dr.
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
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
  (setq evil-auto-indend nil))

(use-package org
  :commands (org-capture)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers t)
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(with-eval-after-load 'org
  (org-babel-do-load-languages 
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)));;specify which languages babel can execute
  (push '("conf-unix" . conf-unix) org-src-lang-modes))
  (setq org-confirm-babel-evaluate nil);;turn off the question "if u wanna execute this block of code"

(with-eval-after-load 'org
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
   (add-to-list 'org-structure-template-alist '("lua" . "src lua"))

  )

(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/init.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package evil-nerd-commenter
:bind ("M-/" . evilnc-comment-or-uncomment-lines))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands(lsp lsp-deferred)
  :hook(lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l");;or change it to whatever u like
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook(lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp);;lsp-treemacs menu
;;we can also enable the sideline via lsp-ui-sideline-enable and lsp-ui-sideline-show-hover

(use-package lsp-ivy
  :after lsp)
;;lsp-ivy-workspace-symbol usage

(use-package typescript-mode
      :mode "\\.ts\\'"
    :hook (typescript-mode . lsp-deferred)
  :config
(setq typescript-indent-level 2))

(use-package lua-mode
  :mode "\\.lua\\'"
  :hook (lua-mode . lsp-deferred)
)

(use-package love-minor-mode)

(use-package company
    :after lsp-mode
    :hook(lsp-mode . company-mode)
    :bind (:map company-active-map
                ("<tab>" . company-complete-selection))
    (:map lsp-mode-map
          ("<tab>" . company-indent-or-complete-common))
    :custom
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.0))
(use-package company-box
:hook(company-mode . company-box-mode))

;;projectile project interaction library for emacs. Offers functionalities for projects 
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects") ;;NOTE: set this path to where you keep git repos
    (setq projectile-project-search-path '("~/Projects"))) ;;NOTE: same for this
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge
  :after magit);;pruza informacije o nekom repozitorijumu, zahteva autentifikaciju sa GitHubom da bi se koristila. PROCITATI DOKUMENTACIJU

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package devdocs)

;;(add-hook 'python-mode-hook
;;          (lambda () (setq-local devdocs-current-docs '("python~3.9"))))

(if (eq system-type 'windows-nt )
    (use-package powershell
      :config
      ;; Change default compile command for powershell
      (add-hook 'powershell-mode-hook
                (lambda ()
                  (set (make-local-variable 'compile-command)
                       (format "powershell.exe -NoLogo -NonInteractive -Command \"& '%s'\"" ))))))

(if (eq system-type 'gnu/linux)
    (use-package vterm
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

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package dired
  :straight nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(setq gc-cons-treshold (* 2 1000 1000))
