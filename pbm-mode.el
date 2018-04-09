;; Usage:
;;   `(add-to-list 'auto-mode-alist '("\\.pbm\\'" . pbm-mode))`
;;
;; References:
;;   http://www.wilfred.me.uk/blog/2015/03/19/adding-a-new-language-to-emacs/

(defconst pbm-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; # is punctuation, but ## is a comment starter
    ;; (modify-syntax-entry ?# ". 12" table)
    (modify-syntax-entry ?# "< 1" table)
    ;; \n is a comment ender
    (modify-syntax-entry ?\n ">" table)
    table))


(setq pbm-highlights
      '(("P1" . font-lock-function-name-face)
        ("0" . font-lock-warning-face)     
        ("1" . font-lock-constant-face)))

(define-derived-mode pbm-mode fundamental-mode "pbm"
  "major mode for editing NetPBM textual graphics files."
  :syntax-table pbm-mode-syntax-table
  (setq font-lock-defaults '(pbm-highlights)))
