;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Sriram Krishna"
      user-mail-address "sriramsk1999@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!


;; UI Configuration
;;######################################################
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 16))
(setq doom-theme 'doom-ayu-dark)
(setq display-line-numbers-type t)
;; Scroll before hitting the top/bottom of the screen
(setq scroll-margin 8)

;;######################################################

;; org-mode Configuration
;;######################################################
(setq org-directory "~/org/")

;; Save-files when exiting insert mode, but only in orgmode
(defun save-if-orgmode()
  (when (equal major-mode 'org-mode)
    (call-interactively #'save-buffer))
  )
(add-hook 'evil-insert-state-exit-hook 'save-if-orgmode)

;; Make folded items searchable in org mode
(setq org-fold-core-style 'overlays)

;; Override some unused evil keybindings
(map! :desc "org jump to next heading"
      :after evil
      :map evil-normal-state-map
      "J" 'org-next-visible-heading)
(map! :desc "org jump to previous heading"
      :after evil
      :map evil-normal-state-map
      "K" 'org-previous-visible-heading)

;; Disable holidays
(setq cfw:display-calendar-holidays nil)

;; Customize the TODO states used
(after! org
  (setq org-todo-keywords
        '((sequence "TODO" "PROG" "|" "DONE")))
  (setq org-todo-keyword-faces
        '(("PROG" . "orange"))
        )
  )

(defun org-time-range-tomorrow ()
  "Return an Org time range for the next day,
start from current time and lasts 1 hour.

TODO: Pass in start time and duration in an *easy* interactive way.

Examples:
(org-time-range-tomorrow)
\"<2024-05-24 Fri 12:30>--<2024-05-24 Fri 13:30>\""
  (interactive)
  (let* ((current-time (org-current-time))
         (tomorrow-time-start (time-add current-time (days-to-time 1)))
         (tomorrow-time-end (time-add tomorrow-time-start (seconds-to-time 3600)))
         (tomorrow-time-start-str (format-time-string "<%F %a %H:%M>" tomorrow-time-start))
         (tomorrow-time-end-str (format-time-string "<%F %a %H:%M>" tomorrow-time-end))
         )
    (insert (concat tomorrow-time-start-str "--" tomorrow-time-end-str))))

(map! :desc "Insert org-mode time-range for tomorrow"
      :after org
      :map org-mode-map
      :localleader
      "d r" 'org-time-range-tomorrow)

(use-package! calfw-blocks
  :after calfw
  :config
  ;; code here will run after the package is loaded
  (setq calfw-blocks-earliest-visible-time '(8 00))
  (setq calfw-blocks-initial-visible-time '(0 0))
  (setq calfw-blocks-lines-per-hour 2)
  (map! (:map cfw:calendar-mode-map
         :m "D"   (lambda () (interactive) (calfw-blocks-change-view-block-nday 1))
         :m "#"   (lambda () (interactive) (calfw-blocks-change-view-block-nday 3))
         :m "W"   #'calfw-blocks-change-view-block-week
         ))
  )

;; Calendar showing org-agenda entries
(defun open-org-calendar-with-blocks ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "White"))
   :view 'block-3-day)
  )

(map! :desc "Open org calendar"
      :leader
      :prefix "o"
      "c" 'open-org-calendar-with-blocks)

;;######################################################

;; python-mode Configuration
;;######################################################
;; Keybind to toggle on/off the format on save hook
(map! :desc "Toggle format-on-save" :leader :prefix "t" "t" 'apheleia-mode)

;; .dir-locals.el snippet to set the virtual env, placed at project root
;; ((nil . ((pyvenv-activate . "~/miniconda3/envs/trackman"))))
;;######################################################

(use-package! xclip
  :config
  (setq xclip-program "wl-copy")
  (setq xclip-select-enable-clipboard t)
  (setq xclip-mode t)
  (setq xclip-method (quote wl-copy)))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; workspace/destroy, temporarily defined here instead of modules/ui/workspace/autoload.el

(defun read-from-file (file)
  (with-temp-buffer
    (insert-file-contents file)
    (read (current-buffer))))

(defun write-to-file (object file)
  "Write OBJECT to FILE in its printed representation."
  (with-temp-file file
    (prin1 object (current-buffer))))

(defun pop-at-index ( idx list_tbd )
  (if (and list_tbd (< 0 idx))
      (cons (car list_tbd) (pop-at-index (1- idx) (cdr list_tbd)))
    (cdr list_tbd)))

(defun +workspace-destroy (name)
  "Destroys a single workspace. Can only
destroy perspectives that were explicitly saved with `+workspace-destroy'.
Returns t if successful, nil otherwise."
  (let* ((fname (expand-file-name +workspaces-data-file persp-save-dir))
         (workspace-names (persp-list-persp-names-in-file fname)))
    (unless (and (member name workspace-names) t)
      (error "'%s' is an invalid workspace" name))
    (let* ((persp-data (read-from-file fname))
           (workspace-idx (cl-position name workspace-names :test 'equal))
           (modified-persp-data (pop-at-index workspace-idx persp-data))
           )
      (write-to-file modified-persp-data fname)
      (not (member name (persp-list-persp-names-in-file fname))))))

(defun +workspace/destroy (name)
  "Destroy a saved workspace on disk."
  (interactive
   (list
    (if current-prefix-arg
        (+workspace-current-name)
      (completing-read
       "Workspace to destroy: "
       (persp-list-persp-names-in-file
        (expand-file-name +workspaces-data-file persp-save-dir))))))
  (if (not (+workspace-destroy name))
      (+workspace-error (format "Couldn't destroy workspace %s" name))
    (+workspace-message (format "Successfully destroyed workspace %s" name) 'success)))

(map! :desc "Destroy saved workspace" :n "SPC TAB D" #'+workspace/destroy)
