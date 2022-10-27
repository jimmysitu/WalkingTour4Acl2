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
  (perm x x))

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

; From proof of not-in-not-perm
;Subgoal *1/2''
;(IMPLIES (AND (CONSP Y)
;              (IN (CAR Y) Z)
;              (IN A (DEL (CAR Y) Z))
;              (NOT (IN A Z))
;              (IN A (CDR Y)))
;         (NOT (PERM (CDR Y) (DEL (CAR Y) Z))))
; [JM] Since (in a (del b z) -> (in a z), this subgoal is a contradition
(defthm in-sub-is-in
  (implies (in a (del b z))
           (in a z)))

;Subgoal *1/5''
;(IMPLIES (AND (CONSP X)
;              (NOT (IN (CAR X) Z))
;              (IN (CAR X) Y)
;              (PERM (CDR X) (DEL (CAR X) Y)))
;         (NOT (PERM Y Z)))
; [JM] It seem if a not in z, but a in y, (perm y z) is false
(defthm not-in-not-perm
  (implies (and (not (in a z))
                (in a y))
           (not (perm y z))))

; From proof of perm-del-del
;Subgoal *1/4.2
;(IMPLIES (AND (CONSP Y)
;              (NOT (EQUAL A (CAR Y)))
;              (PERM (DEL A (CDR Y))
;                    (DEL A (DEL (CAR Y) Z)))
;              (IN (CAR Y) Z)
;              (PERM (CDR Y) (DEL (CAR Y) Z)))
;         (IN (CAR Y) (DEL A Z)))
; [JM] Think of (a <> b) & (in b z) -> (in b (del a z))
(defthm in-del
  (implies (and (not (equal a b))
                (in b z))
           (in b (del a z)))) 

;Subgoal *1/4.1
;(IMPLIES (AND (CONSP Y)
;              (NOT (EQUAL A (CAR Y)))
;              (PERM (DEL A (CDR Y))
;                    (DEL A (DEL (CAR Y) Z)))
;              (IN (CAR Y) Z)
;              (PERM (CDR Y) (DEL (CAR Y) Z)))
;         (PERM (DEL A (CDR Y))
;               (DEL (CAR Y) (DEL A Z))))
; [JM] Try (del a (del b z)) == (del b (del a z))
(defthm del-del
  (equal (del a (del b z))
         (del b (del a z))))

;Subgoal *1/3'''
;(IMPLIES (AND (CONSP X)
;              (IN (CAR X) Z)
;              (NOT (PERM Y (CONS (CAR X) (DEL (CAR X) Z))))
;              (IN (CAR X) Y)
;              (PERM (CDR X) (DEL (CAR X) Y))
;              (PERM Y Z))
;         (PERM (CDR X) (DEL (CAR X) Z)))
; [JM] try (perm y z) -> (perm (del a y) (del a z))
(defthm perm-del-del
  (implies (perm y z)
           (perm (del a y) (del a z))))

; Prove (perm x y) & (perm y z) -> (perm x z)
(defthm perm-transitive
  (implies (and (perm x y) (perm y z))
           (perm x z)))

:trans1 (defequiv perm)

; (DEFTHM PERM-IS-AN-EQUIVALENCE
;         (AND (BOOLEANP (PERM X Y))
;              (PERM X X)
;              (IMPLIES (PERM X Y) (PERM Y X))
;              (IMPLIES (AND (PERM X Y) (PERM Y Z))
;                       (PERM X Z)))
;         :RULE-CLASSES (:EQUIVALENCE))


; Proof target
(defequiv perm)

;;; Exercise 11.6
:trans1 (defcong perm perm (append x y) 1)
#|ACL2s-ToDo-Line|#
; (DEFTHM PERM-IMPLIES-PERM-APPEND-1
;         (IMPLIES (PERM X X-EQUIV)
;                  (PERM (APPEND X Y) (APPEND X-EQUIV Y)))
;         :RULE-CLASSES (:CONGRUENCE))






