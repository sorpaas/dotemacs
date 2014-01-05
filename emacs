;;; Sorpa'as emacs config file
;;; Email: sorpaas@gmail.com

;;; System Config

;;; - Package System
(when (>= emacs-major-version 24)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/")))
  (require 'package)
  (package-initialize)
)

;;; - Window Size
(when window-system (set-frame-size (selected-frame) 170 49))
(add-to-list 'default-frame-alist '(height . 49))

;;; - Split It Now
(split-window-horizontally)

;;; - Bells
(defun my-bell-function ()
  (unless (memq this-command
    	'(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

;;; - Save Mode
(desktop-save-mode 1)

;;; - Backup and Autosave
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

;;; - Theme
(load-theme 'solarized-dark t)

;;; Org Mode

;;; - Org: Init
(require 'org-install)

;;; - Org: Basic Config
(setq org-log-done t)
(setq org-agenda-include-diary t)
(setq org-startup-indented t)
(setq org-agenda-ndays 7)
(setq org-deadline-warning-days 7)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-start-on-weekday nil)
(setq org-reverse-note-order t)
(setq org-fast-tag-selection-single-key (quote expert))
(setq org-remember-store-without-prompt t)
(setq org-remember-templates
      (quote ((116 "* SPECIAL %?\n  %u" "~/Workspace/org/notes.org" "Tasks")
	      (110 "* %u %?" "~/Workspace/org/notes.org" "Notes"))))
(setq remember-annotation-functions (quote (org-remember-annotation)))
(setq remember-handler-functions (quote (org-remember-handler)))
(setq org-default-notes-file "~/Workspace/org/notes.org")

;;; - Org: TODO Keywords
(setq org-todo-keywords 
      '((type 
	 "TODO" ;;; a common todo listed in agenda
	 "GENERAL"
	 "SPECIAL" ;;; top special / urgent items 
	 "WAITING" ;;; tracking todo item, no work need to be done by Brendan 
	 "MISSION" ;;; project tracking item
	 "PROJECT" ;;; project tracking item
	 "|" 
	 "DONE" ;;; achieved item
	 )))
(setq org-todo-keyword-faces
      '(("TODO" . (:background "red1" 
		   :foreground "black" 
		   :weight bold)) 
	("GENERAL" . (:background "sea green" 
		   :foreground "black" 
		   :weight bold)) 
        ("SPECIAL" . (:background "orange" 
		   :foreground "black" 
		   :weight bold ))
	("WAITING" . (:background "gold" 
		   :foreground "black" 
		   :weight bold )) 
	("MISSION" . (:background "blue" 
		   :foreground "black" 
		   :weight bold ))
	("PROJECT" . (:background "light blue" 
		   :foreground "black" 
		   :weight bold ))
	("DONE" . (:foreground "forest green" 
		   :weight bold ))))

;;; - Org: Agenda Commands
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODO's"
	 ((agenda "")
	  (alltodo)))
	("d" "Today's plan"
	 ((agenda "" ((org-agenda-ndays 1)))
	  (todo "GENERAL")
	  (todo "SPECIAL")
	  (todo "TODO" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))))
	  (todo "WAITING")
	  (todo "MISSION")
	  (todo "PROJECT")))))

;;; - Org: Path
(setq org-directory "~/Workspace/org")
(setq org-agenda-files (list "~/Workspace/org"))

;;; - Org: Hooks
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;;; - Org: Key Maps
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

;;; - Org: Clock
(org-clock-persistence-insinuate)
(setq org-clock-history-length 49)
(setq org-clock-in-resume t)
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
(setq org-clock-into-drawer t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-out-when-done t)
(setq org-clock-persist t)
(setq org-clock-persist-query-resume nil)
(setq org-clock-report-include-clocking-task t)

;;; - Org-Mobile
(require 'org-mobile)
(setq org-mobile-inbox-for-pull "~/Workspace/org/notes.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

;;; - Remember
(require 'remember)
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map [(control meta ?r)] 'remember)

;;; - Org-Publish
(require 'org-publish)
(setq org-publish-project-alist
  '(
     ("org-notes"
	   :base-directory "~/Workspace/org/"
	   :base-extension "org"
	   :publishing-directory "~/Workspace/org-publish/"
	   :recursive t
	   :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"site.css\" />"
	   :publishing-function org-publish-org-to-html
	   :headline-levels 4             ; Just the default for this project.
	   :auto-preamble t
	 )
	 ("org-static"
	   :base-directory "~/Workspace/org/"
	   :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	   :publishing-directory "~/Workspace/org-publish"
	   :recursive t
	   :publishing-function org-publish-attachment
	 )
	 ("org" :components ("org-notes" "org-static"))))

;;; Lojban Mode
(setq load-path
      (cons "~/.emacs.d/lojban" load-path))
(autoload 'lojban-parse-region "lojban" nil t)
(autoload 'lojban-mode "lojban-mode" nil t)

;;; Email System
(setq gnus-select-method
      '(nnimap "gmail"
	       (nnimap-address "imap.gmail.com")
	       (nnimap-server-port 993)
	       (nnimap-stream ssl)))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
				   "sorpaas@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
			

;;; Custom

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fill-column 70)
 '(mediawiki-site-alist (quote (("sorpa'as" "http://sorpaas.com/w/" "sorpaas" "Kells2.718281" "Home") ("Wikipedia" "http://en.wikipedia.org/w/" "username" "password" "Main Page"))))
 '(org-agenda-dim-blocked-tasks t)
 '(org-enforce-todo-dependencies t)
 '(org-link-frame-setup (quote ((vm . vm-visit-folder-other-frame) (vm-imap . vm-visit-imap-folder-other-frame) (gnus . org-gnus-no-new-news) (file . find-file-other-window) (wl . wl-other-frame))))
 '(tool-bar-mode nil)
 '(visible-bell nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

