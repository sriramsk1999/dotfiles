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
  (setq calfw-blocks-earliest-visible-time '(7 00))
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

(map! :desc "Export org document to pdf"
      :after org
      :map org-mode-map
      :localleader
      "p" 'org-latex-export-to-pdf)

;;######################################################

;; python-mode Configuration
;;######################################################
;; Keybind to toggle on/off the format on save hook
(map! :desc "Toggle format-on-save" :leader :prefix "t" "t" 'apheleia-mode)

;; .dir-locals.el snippet to set the virtual env, placed at project root
;; ((nil . ((pyvenv-activate . "~/miniconda3/envs/trackman"))))
;;######################################################

;; Misc Configuration
;;######################################################

(after! evil
  (define-key evil-normal-state-map (kbd "<tab>") #'evil-toggle-fold)
  (define-key evil-normal-state-map (kbd "TAB") #'evil-toggle-fold))

(use-package! xclip
  :config
  (setq xclip-program "wl-copy")
  (setq xclip-select-enable-clipboard t)
  (setq xclip-mode t)
  (setq xclip-method (quote wl-copy)))

;; Bind save to Ctrl-s
(map! :desc "save buffer"  "C-s" #'save-buffer)

;; Open emacsclient in same workspace instead of creating new workspace every time
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override
        `(+workspace-current-name))
  )

(after! lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.pixi\\'"))
;; In every project directory - ((nil . ((pyvenv-activate . "./.pixi/envs/default/"))))

;; Setting up gptel ....

(setf (gptel-get-backend "ChatGPT") nil)

;; Default model
(setq
 gptel-model   'grok-4-0709
 gptel-backend
 (gptel-make-openai "xAI"
   :host "api.x.ai"
   :key (getenv "XAI_API_KEY")
   :endpoint "/v1/chat/completions"
   :stream t
   :models '(grok-3-mini-fast-beta grok-3-fast-beta grok-4-0709)))

;; gptel keybindings under the AI prefix (SPC a)
;; Remove the existing binding for "SPC a" (embark-act)
(map! :leader "a" nil)
(map! :leader
      (:prefix ("a" . "AI")
       :desc "Open chat buffer"     "a" #'gptel
       :desc "Send to AI"           "s" #'gptel-send
       :desc "Rewrite with AI"      "r" #'gptel-rewrite
       :desc "Abort response"      "x" #'gptel-abort
       :desc "gptel menu"          "m" #'gptel-menu
       :desc "Add context"          "c" #'gptel-add
       :desc "Add context from file" "f" #'gptel-add-file
       :desc "Clear context"        "C" #'gptel-context-remove-all))

(setq gptel-directives
      '((default . "## ML Research Assistant System Prompt

You are assisting a computer vision and robotics ML researcher.

- Assume intermediate ML knowledge and Python expertise
- Provide concise, technically precise responses
- Default to Python code examples
- Brief explanations focusing on implementation
- For Linux/shell commands, provide practical solutions with minimal explanation
- Prioritize accuracy and directness
- Don't over-explain established ML concepts
- Recommend best approaches rather than listing all options
- Focus on practical solutions for research contexts")))


;;######################################################

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
