; ****************** BEGIN INITIALIZATION FOR ACL2s MODE ****************** ;
; (Nothing to see here!  Your actual file is after this initialization code);

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading the CCG book.~%") (value :invisible))
(include-book "acl2s/ccg/ccg" :uncertified-okp nil :dir :system :ttags ((:ccg)) :load-compiled-file nil);v4.0 change

;Common base theory for all modes.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s base theory book.~%") (value :invisible))
(include-book "acl2s/base-theory" :dir :system :ttags :all)


#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "custom" :dir :acl2s-modes :ttags :all)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem setting up ACL2s mode.") (value :invisible))

;Settings common to all ACL2s modes
(acl2s-common-settings)
;(acl2::xdoc acl2s::defunc) ;; 3 seconds is too much time to spare -- commenting out [2015-02-01 Sun]

(acl2::xdoc acl2s::defunc) ; almost 3 seconds

; Non-events:
;(set-guard-checking :none)

(acl2::in-package "ACL2S")

; ******************* END INITIALIZATION FOR ACL2s MODE ******************* ;
;$ACL2s-SMode$;ACL2s
(defun app (x y) 
  (cond ((endp x) y) 
        (t (cons (car x) 
                 (app (cdr x) y))))) 

(app nil '(x y z))
(app '(1 2 3) '(4 5 6 7))
(app '(a b c d e f g) '(x y z))
(app (app '(1 2) '(3 4)) '(5 6))
(app '(1 2) (app '(3 4) '(5 6)))
(let ((a '(1 2)) 
            (b '(3 4)) 
            (c '(5 6))) 
        (equal (app (app a b) c) 
               (app a (app b c))))

; Free variables not given values
;(equal (app (app a b) c) 
;              (app a (app b c)))) 

; set gag mode to see proof procedure 
:set-gag-mode nil 
; Theorem define
(defthm associativity-of-app 
  (equal (app (app a b) c) 
         (app a (app b c))) 
  :rule-classes nil) 

; set gag mode back to default
:set-gag-mode :goals 
; Trivial example
(defthm trivial-consequence
  (equal (app (app (app (app x1 x2) (app x3 x4)) (app x5 x6)) x7)
         (app x1 (app (app x2 x3) (app (app x4 x5) (app x6 x7))))))#|ACL2s-ToDo-Line|#







