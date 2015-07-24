;;;
;;; interactive/toplevel.scm - toplevel commands
;;;
;;;   Copyright (c) 2015  Shiro Kawai  <shiro@acm.org>
;;;
;;;   Redistribution and use in source and binary forms, with or without
;;;   modification, are permitted provided that the following conditions
;;;   are met:
;;;
;;;   1. Redistributions of source code must retain the above copyright
;;;      notice, this list of conditions and the following disclaimer.
;;;
;;;   2. Redistributions in binary form must reproduce the above copyright
;;;      notice, this list of conditions and the following disclaimer in the
;;;      documentation and/or other materials provided with the distribution.
;;;
;;;   3. Neither the name of the authors nor the names of its contributors
;;;      may be used to endorse or promote products derived from this
;;;      software without specific prior written permission.
;;;
;;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;;   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;;   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;;   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;;;   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;;   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;

;; This module is autoloaded from gauche.interactive.

;;; Scheme48-style toplevel commands
;;;
;;;   ,command arg ...
;;;
;;; Command is a word (Scheme identifier).  After the command, characters
;;; until EOL are read and splitted into arguments in similar way to shell
;;; command-line processing.
;;;
;;; The initial ,command part is read by read - which becomes (unquote command)
;;; - and then the control passed to handle-toplevel-command.

(define-module gauche.interactive.toplevel
  (use gauche.interactive)
  (use gauche.threads)
  (use srfi-13)
  (use util.match)
  (export handle-toplevel-command)
  )
(select-module gauche.interactive.toplevel)

(autoload file.util home-directory expand-path)

;; toplevel-commands
;; Map from symbol to (help-message proc)
(define *toplevel-commands* (atom (make-hash-table 'eq?)))

(define (toplevel-command-add! key help handler)
  (atomic *toplevel-commands* (^t (hash-table-put! t key `(,help ,handler)))))

(define (toplevel-command-lookup key)
  (atomic *toplevel-commands* (^t (hash-table-get t key #f))))

(define (toplevel-command-keys)
  (atomic *toplevel-commands* hash-table-keys))

;; A handler return value that does nothing
(define *no-value* `(,(with-module gauche values)))

(define (toplevel-command-helper key)
  (^[]
    (if-let1 help&prc (toplevel-command-lookup key)
      (print "Usage: " (car help&prc))
      (print "Unknown toplevel command: " key))
    *no-value*))

(define-syntax define-toplevel-command
  (er-macro-transformer
   (^[f r c]
     (match f
       [(_ key help handler)
        `(,(r'toplevel-command-add!) (,(r'quote) ,key) ,help
          (,(r'let1) usage (,(r'toplevel-command-helper) (,(r'quote) ,key))
           ,handler))]))))

;; API
;; Entry point - called by REPL reader.
;; Whatever the handler returns, it is treated as if it's read
;; from the input.  If you don't need the result to be evaluated,
;; you can return *no-value*.
(define (handle-toplevel-command command line)
  (unless (symbol? command)
    (error "Invalid REPL toplevel command:" command))
  (if-let1 help&handler (toplevel-command-lookup command)
    ;; Just for now - we'll employ more sophisticated parser later
    (let* ([argline (string-trim-both line)]
           [args (if (equal? argline "")
                   '()
                   (string-split (string-trim-both line) #/\s+/))])
      ((cadr help&handler) args))
    (error "Unrecognized REPL toplevel command:" command)))

;;
;; Predefined commands
;;

(define-toplevel-command a
  "a regexp [module-name]\n\
 Apropos.  Show the names of global bindings that match the regexp.\n\
 If module-name (symbol) is given, the search is limited in the named module."
  (^[args]
    (match args
      [(word) `(apropos ,(string->regexp word))]
      [(word mod) `(apropos ,(string->regexp word) ',(string->symbol mod))]
      [_ (usage)])))

(define-toplevel-command d
  "d [object]\n\
 Describe the object.\nWithout arguments, describe the last REPL result."
  (^[args]
    (match args
      [() `(,(with-module gauche.interactive describe))]
      [(obj) `(,(with-module gauche.interactive describe)
               ,(read-from-string obj))]
      [_ (usage)])))

(define-toplevel-command help
  "help [command]\n\
 Show the help message of the command.\n\
 Without arguments, show the list of all toplevel commands."
  (^[args]
    (match args
      [()
       (print "You're in REPL (read-eval-print-loop) of Gauche shell.")
       (print "Type a Scheme expression to evaluate.")
       (print "A word preceeded with comma has special meaning.  Type ,help <cmd> to see the detailed help for <cmd>.")
       (dolist [cmd (sort (toplevel-command-keys)) *no-value*]
         (let1 h&h (toplevel-command-lookup cmd)
           (format #t " ,~8a ~a\n" cmd
                   (list-ref (call-with-input-string (car h&h)
                               port->string-list)
                             1 ""))))]
      [(cmd) ((toplevel-command-helper (string->symbol cmd)))])))

(define-toplevel-command pwd
  "pwd\n\
 Print working directory."
  (^[args]
    (match args
      [() (print (sys-getcwd)) *no-value*]
      [_ (usage)])))

(define-toplevel-command cd
  "cd [directory]\n\
 Change the current directory.\n\
 Without arguments, change to the home directory."
  (^[args]
    (let1 dir (match args
                [() (home-directory)]
                [(dir) (expand-path dir)]
                [_ #f])
      (if dir
        (begin (sys-chdir dir) (sys-getcwd))
        (usage)))))

       
   
    

