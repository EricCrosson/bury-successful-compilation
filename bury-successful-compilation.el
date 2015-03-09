;;; bury-successful-compilation.el --- Bury the *compilation* buffer after successful compilation
;; Version: 0.0.20140308

;; Copyright (C) 2015 Eric Crosson

;; Author: Eric Crosson <esc@ericcrosson.com>
;; Keywords: compilation
;; Package-Version: 0.2

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

;; (bury-successful-compilation 1)

;;; Code

(defgroup bscb nil
  "Bury successful *compilation* buffers."
  :group 'bscb)

(defcustom bury-successful-compilation-precompile-window-state nil
  "Storage for `bury-successful-compilation' to restore
window configuration after a successful compilation."
  :type 'boolean
  :group 'bscb)

(defcustom bury-successful-compilation-save-windows t
  "If nil, the user is attempting to recompile after a failed
attempt. What this means to advice
`bury-successful-compilation-save-window' is now is not
the time to save current-window configuration to variable
`bury-successful-compilation-precompile-window-state'."
  :type 'boolean
  :group 'bscb)

(defadvice compilation-start (before
			      bury-successful-compilation-save-windows
			      activate)
  "Save window configuration to
`bury-successful-compilation-precompile-window-state' unless `bury-successful-compilation-save-windows' is nil."
  (when bury-successful-compilation-save-windows
    (window-configuration-to-register
     bury-successful-compilation-precompile-window-state)))

(defun bury-successful-compilation-buffer (buffer string)
  "Bury the compilation BUFFER after a successful compile.
Argument STRING provided by compilation hooks."
  (setq bury-successful-compilation-save-windows
	(and
	 (string-match "compilation" (buffer-name buffer))
	 (string-match "finished" string)
	 (not (search-forward "warning" nil t))))
  (when bury-successful-compilation-save-windows
    (ignore-errors
      (jump-to-register
       bury-successful-compilation-precompile-window-state))
    (message "Compilation successful.")))

(defun bury-successful-compilation-turn-on ()
  "Turn on function `bury-successful-compilation'."
  (ad-enable-advice 'compilation-start 'before
'bury-successful-compilation-save-windows)
  (add-hook 'compilation-finish-functions 'bury-successful-compilation-buffer))

(defun bury-successful-compilation-turn-off ()
  "Turn off function `bury-successful-compilation'."
  (setq bury-successful-compilation-precompile-window-state nil)
  (ad-disable-advice 'compilation-start 'before
		     'bury-successful-compilation-save-windows)
  (remove-hook 'compilation-finish-functions
	       'bury-successful-compilation-buffer))

;;;###autoload
(define-minor-mode bury-successful-compilation
  "A minor mode to bury the *compilation* buffer upon successful
compilations."
  :init-value nil
  :global t
  :group 'bscb
  (if bury-successful-compilation
      (bury-successful-compilation-turn-on)
    (bury-successful-compilation-turn-off)))

(provide 'bury-successful-compilation)

;;; bury-successful-compilation.el ends here
