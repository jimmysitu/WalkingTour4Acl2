(in-package "ACL2")
(include-book "ordinals/e0-ordinal" :dir :system)
(set-well-founded-relation e0-ord-<)

;;; Exercise 11.1
(defun f (x)
  (if (endp x)
    0
    (1+ (f (cdr x)))))
; f is admissible

(defun g (x)
  (declare (xargs :measure
                  (if (true-listp x) (acl2-count x) (1+ (acl2-count x)))))
  (if (null x)
    0
    (1+ (g (cdr x)))))
; g is also admissible

;;; Exercise 11.2
(defun app (x y)
  (if (endp x)
      y
    (cons (car x)
          (app (cdr x) y))))

(defun rev (x)
  (if (endp x)
      nil
    (app (rev (cdr x)) (list (car x)))))


(defun flatten (x)
  (if (atom x)
    (list x)
    (app (flatten (car x))
         (flatten (cdr x)))))

(defun swap-tree (x)
  (if (atom x)
    x
    (cons (swap-tree (cdr x))
          (swap-tree (car x)))))

; Proof target
(defthm flatten-swap-tree-is-rev-flatten
  (equal (flatten (swap-tree x)) (rev (flatten x))))

; Define and admit flat from chp7.3
(defun flat (x)
  (declare (xargs :measure
                  (cons (+ 1 (acl2-count x))
                        (acl2-count (car x)))))
  (cond ((atom x) (list x))
        ((atom (car x)) (cons (car x) (flat (cdr x))))
        (t (flat (cons (caar x)
                       (cons (cdar x) (cdr x)))))))

; Proof target: flat and flatten is equal
(defthm flat-flatten
  (equal (flatten (swap-tree x))
         (rev (flatten x))))

;;; Exercise 11.3
; Proof helper
;Subgoal *1/3'''
;(IMPLIES (AND (CONSP X)
;              (EQUAL (REVAPPEND (REVAPPEND (CDR X) NIL) NIL)
;                     (CDR X)))
;         (EQUAL (REVAPPEND (REVAPPEND (CDR X) (LIST (CAR X)))
;                           NIL)
;                X))
; [JM] It seem we need something like, 
;      (revappend (revappend x y) z) = ....
(defthm revappend-revappend
  (equal (revappend (revappend x y) z)
         (revappend y (append x z))))
; Proof target
(defthm reverse-reverse
  (implies (true-listp x)
           (equal (reverse (reverse x))
                  x)))

;;; Exercise 11.4
(defun rev (x)
  (if (endp x)
    nil
    (app (rev (cdr x)) (list (car x)))))

; Proof helpers
;Subgoal *1/3''
;(IMPLIES (AND (CONSP X)
;              (EQUAL (REV (CDR X))
;                     (REVAPPEND (CDR X) NIL))
;              (NOT (STRINGP X)))
;         (EQUAL (APP (REV (CDR X)) (LIST (CAR X)))
;                (REVAPPEND (CDR X) (LIST (CAR X)))))
; [JM] It seems we need to proof
;      (app (rev x) y) = revappend x y
(defthm app-rev-revappend
  (equal (app (rev x) y)
         (revappend x y)))

; Proof target
(defthm rev-reverse
  (implies (not (stringp x))
           (equal (rev x)
                  (reverse x))))#|ACL2s-ToDo-Line|#


