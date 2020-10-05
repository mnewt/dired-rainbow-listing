;;; dired-rainbow-listing.el --- Colorful Dired listings -*- lexical-binding: t -*-

;; Author: Matthew Sojourner Newton
;; Maintainer: Matthew Sojourner Newton
;; Version: 0.1
;; Package-Requires: ((emacs "25.1"))
;; Homepage: https://github.com/mnewt/dired-rainbow-listing
;; Keywords: convenience faces files


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; This Emacs package adds customizable highlighting to `dired' listings.  It
;; works well alongside dired-hacks, and specifically dired-rainbow.

;;; Code:

(defface dired-rainbow-listing-inodes '((t (:inherit shadow)))
  "Face for Dired links."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-user '((t (:inherit default)))
  "Face for Dired user."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-group
  '((((background dark)) (:inherit default :foreground "#999"))
    (t (:inherit default :foreground "#777")))
  "Face for Dired group."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-size '((t (:inherit default)))
  "Face for Dired file size."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-datetime
  '((((background dark)) (:inherit default :foreground "#999"))
    (t (:inherit default :foreground "#777")))
  "Face for Dired timestamp."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-file-listing-extension '((t (:inherit shadow)))
  "Face for Dired file extensions."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-file-listing-decoration '((t (:inherit font-lock-comment-face)))
  "Face for file decoration."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-dash '((t (:inherit shadow)))
  "Face for file decoration."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-permissions-r
  '((((background dark)) (:inherit default :foreground "#999"))
    (t (:inherit default :foreground "#777")))
  "Face for the r in Dired permissions"
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-permissions-w
  '((((background dark)) (:inherit default :foreground "#AAA"))
    (t (:inherit default :foreground "#666")))
  "Face for the w in Dired permissions"
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-permissions-x
  '((((background dark)) (:inherit default :foreground "#BBB"))
    (t (:inherit default :foreground "#555")))
  "Face for the x in Dired permissions"
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-filetype-directory '((t (:inherit font-lock-function-name-face)))
  "Face for file decoration."
  :group 'dired-rainbow-listing)

(defface dired-rainbow-listing-filetype-link '((t (:inherit font-lock-string-face)))
  "Face for file decoration."
  :group 'dired-rainbow-listing)

(defvar dired-rainbow-listing-permissions-regexp "[-dl][-rwxlsStT]\\{9\\}[.+-@]?"
  "A regexp matching the permissions in the dired listing.")

(defvar dired-rainbow-listing-inodes-regexp "[0-9]+"
  "A regexp matching the number of links in the dired listing.")

(defvar dired-rainbow-listing-user-or-group-regexp "[a-z_][a-z0-9_-]*"
  "A regexp matching the user and group in the dired listing.")

(defvar dired-rainbow-listing-size-regexp "[0-9.]+[kKmMgGtTpPi]\\{0,3\\}"
  "A regexp matching the file size in the dired listing.")

(defvar dired-rainbow-listing-datetime-regexp
  "\\sw\\sw\\sw....\\(?:[0-9][0-9]:[0-9][0-9]\\|.[0-9]\\{4\\}\\)"
  "A regexp matching the date/time in the dired listing.

It is used to determine where the filename starts.  It should
*not* match any characters after the last character of the
timestamp.  It is assumed that the timestamp is preceded and
followed by at least one space character.  You should only use
shy groups (prefixed with ?:) because the first group is used by
the font-lock to determine what portion of the name should be
colored.

Stolen from `dired-hacks'.")

(defvar dired-rainbow-listing-details-regexp
  (let ((sep "\\) +\\("))
    (concat "^ +\\("
            dired-rainbow-listing-permissions-regexp sep
            dired-rainbow-listing-inodes-regexp sep
            dired-rainbow-listing-user-or-group-regexp sep
            dired-rainbow-listing-user-or-group-regexp sep
            dired-rainbow-listing-size-regexp sep
            dired-rainbow-listing-datetime-regexp
            "\\)")))

(defvar dired-rainbow-listing-keywords
  `((,(concat "\\(total used in directory\\|available\\) +\\("
       dired-rainbow-listing-size-regexp "\\)")
     (1 'font-lock-comment-face)
     (2 'default))
    ("^ +\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +\\(d\\)" 1 'dired-rainbow-listing-filetype-directory)
    ("^ +\\(l\\)" 1 'dired-rainbow-listing-filetype-link)
    ("^ +.\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +..\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +...\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +....\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +.....\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +......\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +.......\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +........\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +.........\\(-\\)" 1 'dired-rainbow-listing-dash)
    ("^ +.\\(r\\)" 1 'dired-rainbow-listing-permissions-r)
    ("^ +....\\(r\\)" 1 'dired-rainbow-listing-permissions-r)
    ("^ +.......\\(r\\)" 1 'dired-rainbow-listing-permissions-r)
    ("^ +..\\(w\\)" 1 'dired-rainbow-listing-permissions-w)
    ("^ +.....\\(w\\)" 1 'dired-rainbow-listing-permissions-w)
    ("^ +........\\(w\\)" 1 'dired-rainbow-listing-permissions-w)
    ("^ +...\\(x\\)" 1 'dired-rainbow-listing-permissions-x)
    ("^ +......\\(x\\)" 1 'dired-rainbow-listing-permissions-x)
    ("^ +.........\\(x\\)" 1 'dired-rainbow-listing-permissions-x)
    (,dired-rainbow-listing-details-regexp
     (2 'dired-rainbow-listing-inodes)
     (3 'dired-rainbow-listing-user)
     (4 'dired-rainbow-listing-group)
     (5 'dired-rainbow-listing-size)
     (6 'dired-rainbow-listing-datetime))
    ("\\.[^. /:*]+$" 0 'dired-rainbow-file-listing-extension t)
    ("\\([*/]\\| -> .*\\)" 1 'dired-rainbow-file-listing-decoration t)))

;;;###autoload
(define-minor-mode dired-rainbow-listing-mode
  "Toggle highlighting of file listing details in Dired."
  :group 'dired-rainbow
  :lighter nil
  (setq font-lock-defaults
        (if dired-rainbow-listing-mode
            '((dired-font-lock-keywords
               dired-rainbow-listing-keywords)
              t nil nil beginning-of-line)
          '(dired-font-lock-keywords t nil nil beginning-of-line)))
  (font-lock-refresh-defaults))

(provide 'dired-rainbow-listing)

;;; dired-rainbow-listing.el ends here
