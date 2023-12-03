;; -*- lexical-binding: t; -*-

(defvar inputrc-mode--read-manpage-exe (expand-file-name "readline.awk"))

(defun inputrc-mode--read-manpage ()
  "Get readline \"set\" variables, commands and descriptions from manpage."
  (with-temp-buffer
    (unless (zerop (call-process-shell-command
                    (format (concat "env TERM=dumb MAN_KEEP_FORMATTING=1 "
                                    "man 3 readline 2>/dev/null | awk -f %s")
                            inputrc-mode--read-manpage-exe)
                    nil (current-buffer) nil))
      (user-error "Failed to read readline variables"))
    (goto-char (point-min))
    (read (current-buffer))))
