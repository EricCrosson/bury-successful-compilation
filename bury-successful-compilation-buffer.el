;;; bury-successful-compilation-buffer.el --- Bury the *compilation*
;;; buffer when the compilation succeeds
;; Version: 0.0.20140227

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

;; This package provides commands for moving the buffer slightly up or
;; down without adjusting point.

;; Usage:

;; (bury-successful-compilation-buffer-mode 1)
;; (global-set-key (kbd "C-c C-m" 'bscb/recompile))

;;; Code

;;;###autoload
(define-minor-mode bury-successful-compilation-buffer-mode
  "A minor mode to bury the *compilation* buffer upon successful
compilations."
  :init-value t
  :global t
  :variable bury-successful-compilation-buffer-mode
  :group 'compilation
  (if bury-successful-compilation-buffer-mode
      (add-hook 'compilation-finish-functions
		'bury-compilation-buffer-if-successful)
    (remove-hook 'compilation-finish-functions
		 'bury-compilation-buffer-if-successful)))

(defvar bscb-precompile-window-state nil
  "Storage for `bscb/recompile' to restore window configuration
after a successful compilation.")

(defvar bscb-precompile-window-norestore nil
  "If non-nil, the user is attempting to recompile after a failed
attempt. What this means to `bscb/recompile' is now is not the
time to save current-window configuration to
`bscb-precompile-window-state'.")

(defun bury-compilation-buffer-if-successful (buffer string)
  "Bury the compilation BUFFER after a successful compile.
Argument STRING provided by compilation hooks."
  (if (not (and
	    (string-match "compilation" (buffer-name buffer))
	    (string-match "finished" string)
	    (not (search-forward "warning" nil t))))
      (setq bscb-precompile-window-norestore t)
    (setq bscb-precompile-window-norestore nil)
    (jump-to-register bscb-precompile-window-state)
    (message "Compilation successful.")))

;;;###autoload
(defun bscb/recompile ()
  "Save current window configuration to
`bscb-precompile-window-state' and execute
`recompile'. `bury-compilation-buffer-if-successful' will
bury the compilation buffer if compilation succeeds."
  (interactive)
  (when (not bscb-precompile-window-norestore)
      (window-configuration-to-register bscb-precompile-window-state))
    (recompile))

(provide 'bury-successful-compilation-buffer)

;;; bury-successful-compilation-buffer.el ends here
