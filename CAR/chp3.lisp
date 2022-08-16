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
(let ((x 3))
  (let ((x 1)
        (y x))
    (+ x y)))
;[JM] From exe 3.6, the lambda is actully doing 1+X. For 3.8, X=3, so the return should be 4

; Replace let with let*, check the expansion
:trans1 (let* ((x 1)
              (y x))
         (+ x y))

:trans (let* ((x 1)
             (y x))
        (+ x y))
;[JM] It is actually doing X+X
(let* ((x 1)
       (y x))
  (+ x y))#|ACL2s-ToDo-Line|#

;[JM] With X=1, which should return 2

(let ((x 3))
  (declare (ignore x))
  (let* ((x 1)  ; x is 1
         (y x)) ; y is 1
    (+ x y)))