;; init.scm - runs at startup with editor context
(require "helix/configuration.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (only-in "helix/ext.scm" evalp eval-buffer))

;; steel LSP for scheme files
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-language "scheme" (language-servers '("steel-language-server")))

;; file watcher
(require "helix-file-watcher/file-watcher.scm")
(spawn-watcher 1000)
