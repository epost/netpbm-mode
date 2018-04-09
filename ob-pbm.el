;;; ob-pbm.el --- org-babel functions for pbm evaluation

;; Copyright (C) 2018 Shinsetsu.

;; Author: Erik Post
;; Keywords: literate programming, reproducible research, NetPBM, graphics
;; Homepage: http://orgmode.org

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Usage: (require 'ob-pbm)
;;
;; This code currently relies on the presence or the ImageMagick 'convert'
;; shell command.
;;
;; This code was adapted from ob-dot.el

;;; Code:
(require 'ob)

(defvar org-babel-default-header-args:pbm
  '((:results . "file") (:exports . "results"))
  "Default arguments to use when evaluating a pbm source block.")

(defun org-babel-expand-body:pbm (body params)
  "Expand BODY according to PARAMS, return the expanded body."
  (let ((vars (org-babel--get-vars params)))
    (mapc
     (lambda (pair)
       (let ((name (symbol-name (car pair)))
	     (value (cdr pair)))
	 (setq body
	       (replace-regexp-in-string
		(concat "$" (regexp-quote name))
		(if (stringp value) value (format "%S" value))
		body
		t
		t))))
     vars)
    body))



(defun org-babel-execute:pbm (body params)
  "Execute a block of Pbm code with org-babel.
This function is called by `org-babel-execute-src-block'."
  (let* ((result-params (cdr (assoc :result-params params)))
	 (out-file (cdr (or (assoc :file params)
			    (error "You need to specify a :file parameter"))))

         (widthOrNil (cdr (assoc :width params)))
         (width (if widthOrNil (number-to-string widthOrNil) ""))
         (heightOrNil (cdr (assoc :height params)))
         (height (if heightOrNil (number-to-string heightOrNil) ""))
         (scale (if (or widthOrNil heightOrNil) (concat "-scale " width "x" height) ""))

	 (cmdline (or (cdr (assoc :cmdline params))))
	 (cmd (or (cdr (assoc :cmd params)) "convert"))
	 (in-file (org-babel-temp-file "pbm-")))
    (with-temp-file in-file
      (insert (org-babel-expand-body:pbm body params)))
    (org-babel-eval
     (concat cmd
	     " -negate"
             " " scale
;;           " -fill 'rgb(80,80,80)' -opaque white"
	     " " cmdline
	     " " (org-babel-process-file-name in-file)
	     " " (org-babel-process-file-name out-file)) "")
    nil)) ;; signal that output has already been written to file

(defun org-babel-prep-session:pbm (session params)
  "Return an error because PBM does not support sessions."
  (error "PBM does not support sessions"))

(provide 'ob-pbm)


;; : convert -scale 600 -negate -fill 'rgb(80,80,80)' -opaque white sprite-ship.P1.pbm sprite-ship.P1.png
;; 
;; [[./examples/sprite-ship.P1.png]]
