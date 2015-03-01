;;; bury-successful-compilation-buffer-mode.el --- Bury the
;;; *compilation* buffer when the compilation succeeds
;; Version: 0.0.20140228

;; Copyright (C) 2015 Eric Crosson

;; Author: Eric Crosson <esc@ericcrosson.com>
;; Keywords: compilation
;; Package-Version: 0

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a minor mode that will do two things
;; after a successful recompile:
;; 1) bury the *compilation* buffer, and
;; 2) restore your window configuration to how it looked when you
;; issued the recompile.

;; Usage:

;; (bury-successful-compilation-buffer-mode 1)

;;; Code

(defcustom bscb-precompile-window-state nil
  "Storage for `bscb/recompile' to restore window configuration
after a successful compilation."
  :type 'boolean
  :group 'bscb)

(defcustom bscb-precompile-window-save t
  "If nil, the user is attempting to recompile after a failed
attempt. What this means to `bscb-save-window' is now is not the
time to save current-window configuration to
`bscb-precompile-window-state'."
  :type 'boolean
  :group 'bscb)

(defadvice compilation-start (before bscb-save-window activate)
  "Save window configuration to `bscb-precompile-window-state'
unless `bscb-precompile-window-save' is nil."
  (when bscb-precompile-window-save
    (window-configuration-to-register bscb-precompile-window-state)))

(defun bury-successful-compilation-buffer (buffer string)
  "Bury the compilation BUFFER after a successful compile.
Argument STRING provided by compilation hooks."
  (setq bscb-precompile-window-save
	(and
	 (string-match "compilation" (buffer-name buffer))
	 (string-match "finished" string)
   (not (search-forward "warning" nil t))))
  (when bscb-precompile-window-save
    (jump-to-register bscb-precompile-window-state)
    (message "Compilation successful.")))

(defun bscb-turn-on ()
  "Turn on function `bury-successful-compilation-buffer-mode'."
  (ad-enable-advice 'compilation-start 'before 'bscb-save-window)
  (add-hook 'compilation-finish-functions 'bury-successful-compilation-buffer))

(defun bscb-turn-off ()
  "Turn off function `bury-successful-compilation-buffer-mode'."
  (setq bscb-precompile-window-state nil)
  (ad-disable-advice 'compilation-start 'before 'bscb-save-window)
  (remove-hook 'compilation-finish-functions 'bury-successful-compilation-buffer))

;;;###autoload
(define-minor-mode bury-successful-compilation-buffer-mode
  "A minor mode to bury the *compilation* buffer upon successful
compilations."
  :init-value nil
  :global t
  :group 'bscb
  (if bury-successful-compilation-buffer-mode
      (bscb-turn-on)
    (bscb-turn-off)))

(provide 'bury-successful-compilation-buffer-mode)

;;; bury-successful-compilation-buffer-mode.el ends here
