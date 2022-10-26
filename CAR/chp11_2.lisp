;;; Exercise 11.5
; Define the noation of a permutation
(defun in (a b)
  (cond ((atom b) nil)
        ((equal a (car b)) t)
        (t (in a (cdr b)))))

(defun del (a x)
  (cond ((atom x) nil) 
        ((equal a (car x)) (cdr x))
        (t (cons (car x) (del a (cdr x))))))

(defun perm (x y)
  (cond ((atom x) (atom y))
        (t (and (in (car x) y)
                (perm (cdr x) (del (car x) y))))))

; Proof helpers
; Prove (perm x x)
(defthm perm-reflexive
  (perm x x))#|ACL2s-ToDo-Line|#


; Proof help of symmetric
;Subgoal *1/3''
;(IMPLIES (AND (CONSP X)
;              (IN (CAR X) Y)
;              (PERM (DEL (CAR X) Y) (CDR X))
;              (PERM (CDR X) (DEL (CAR X) Y)))
;         (PERM Y X))
; [JM] TBD, not sure how to think out of this perm-del
(defthm perm-del
  (implies (in a y)
           (equal (perm (del a y) x)
                  (perm y (cons a x))))
  :hints (("Goal"
           :induct (perm y x))))

; Prove (perm x y) -> (perm y x)
(defthm perm-symmetric
  (implies (perm x y) (perm y x)))

; Proof helper of transitive
;Subgoal *1/5''
;(IMPLIES (AND (CONSP X)
;              (NOT (IN (CAR X) Z))
;              (IN (CAR X) Y)
;              (PERM (CDR X) (DEL (CAR X) Y)))
;         (NOT (PERM Y Z)))
; [JM] It seem if a not in z, but a in y, (perm y z) is false

;Subgoal *1/3'''
;(IMPLIES (AND (CONSP X)
;              (IN (CAR X) Z)
;              (NOT (PERM Y (CONS (CAR X) (DEL (CAR X) Z))))
;              (IN (CAR X) Y)
;              (PERM (CDR X) (DEL (CAR X) Y))
;              (PERM Y Z))
;         (PERM (CDR X) (DEL (CAR X) Z)))

; Prove (perm x y) & (perm y z) -> (perm x z)
(defthm perm-transitive
  (implies (and (perm x y) (perm y z))
           (perm x z)))

; Proof target
(defequiv perm)