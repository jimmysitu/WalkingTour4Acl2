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
; Chp3
;;; Exercise 3.6
:trans (cond ((equal op 'incrmt) (+ x 1))
            ((equal op 'double) (* x 2))
            (t 0))

:trans (let ((x 1)
             (y x))
         (+ x y))

;;; Exercise 3.7
:trans (case op
      (incrmt (+ x 1))
      (double (* x 2))
      (otherwise 0))

;;; Exercise 3.8
;(let ((x 3)
;      (y x))
;  (+ x y))
;)
;
;:trans1 (let* ((x 1)
;              (y x))
;         (+ x y))

;;; Execrise 3.9
;1. twice the sum of x and y
(let ((x 3)
      (y 4))
  (* 2 (+ x y)))
; test one more
(let ((x 6)
      (y 4))
  (* 2 (+ x y)))

;2. the car of the cdr of x
(let ((x '(1 2 3)))
  (car (cdr x)))
; test another one list
(let ((x '(1 '(2 3))))
  (car (cdr x)))
; try to understand what happen here
(let ((x '(1 '(2 3))))
  (cdr x))
; try others
(let ((x '(1 2 (3 4))))
  (car (cdr x)))

;3. x is y
(let ((x 1) (y 1))
  (equal x y))

(let ((x 1) (y 2))
  (equal x y))

;4. x is a non-integer rational number
(let ((x 1))
  (and (not (integerp x)) (rationalp x)))

(let ((x 1/2))
  (and (not (integerp x)) (rationalp x)))

;5. x is a symbol in the package SMITH
(let ((x 1))
  (and (symbolp x) (equal (symbol-package-name x) "SMITH")))

;6. 0, if x is a string; 1, otherwise
(let ((x "I am a string"))
  (if (stringp x) 0 1))
  
(let ((x 1))
  (if (stringp x) 0 1))#|ACL2s-ToDo-Line|#




