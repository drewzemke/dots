;; helix.scm - functions exported here become typed commands
(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(provide shell jj-track open-helix-scm open-init-scm)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

;;@doc
;; Run shell command, % expands to current file path
(define (shell . args)
  (helix.run-shell-command
    (string-join
      (map (lambda (x) (if (equal? x "%") (current-path) x)) args)
      " ")))

;;@doc
;; Track current file in jj
(define (jj-track)
  (shell "jj" "file" "track" "%"))

;;@doc
;; Open helix.scm for editing
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))

;;@doc
;; Open init.scm for editing
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))
