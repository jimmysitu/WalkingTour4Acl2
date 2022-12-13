;;; Exercise 11.47
(defun how-many (e x)
  (cond ((endp x) 0)
        ((equal e (car x)) (+ 1 (how-many e (cdr x))))
        (t (how-many e (cdr x)))))


;;; Exercise 11.48
;(include-book "arithmetic/top-with-meta" :dir :system)
; [JM] Copy from chp11.2
(defun split-list (x)
  (cond ((endp x) (mv nil nil))
        (t (mv-let (evens odds)
                   (split-list (cdr x))
                   (mv (cons (car x) odds) evens)))))

(defun merge2 (x y)
  (declare (xargs :measure (+ (acl2-count x) (acl2-count y)))) 
  (cond ((endp x) y)
        ((endp y) x)
        ((< (car x) (car y))
         (cons (car x) (merge2 (cdr x) y)))
        (t (cons (car y) (merge2 x (cdr y))))))

(defthm measure-of-mergesort
  (and (implies (and (not (endp x))
                     (not (endp (cdr x))))
                (o< (acl2-count (mv-nth 1 (split-list x)))
                    (acl2-count x)))
       (implies (and (not (endp x))
                     (not (endp (cdr x))))
                (o< (acl2-count (mv-nth 0 (split-list x)))
                    (acl2-count x)))))

(defun mergesort (x)
  (declare (xargs :measure (acl2-count x)
                  :hints (("Goal" :use measure-of-mergesort))
                  ))
  (cond ((endp x) nil)
        ((endp (cdr x)) x)
        (t (mv-let (odds evens)
                   (split-list x)
                   (merge2 (mergesort odds) (mergesort evens))))))

; Proof helper
;Subgoal *1/3.2'
;(IMPLIES
;  (AND (CONSP LST)
;       (CONSP (CDR LST))
;       (EQUAL (HOW-MANY (CAR LST)
;                        (MERGESORT (CONS (CAR LST)
;                                         (MV-NTH 1 (SPLIT-LIST (CDR LST))))))
;              (+ 1
;                 (HOW-MANY (CAR LST)
;                           (MV-NTH 1 (SPLIT-LIST (CDR LST))))))
;       (EQUAL (HOW-MANY (CAR LST)
;                        (MERGESORT (CAR (SPLIT-LIST (CDR LST)))))
;              (HOW-MANY (CAR LST)
;                        (CAR (SPLIT-LIST (CDR LST))))))
;  (EQUAL
;       (HOW-MANY (CAR LST)
;                 (MERGE2 (MERGESORT (CONS (CAR LST)
;                                          (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;                         (MERGESORT (CAR (SPLIT-LIST (CDR LST))))))
;       (+ 1 (HOW-MANY (CAR LST) (CDR LST)))))
;
; [JM] It seem need to proof (how-many a (cons a lst)) = 1 + (how-many a lst)
(defthm how-many-cons
  (equal (how-many a (cons a lst))
         (+ 1 (how-many a lst))))

(defthm how-many-merge2
  (equal (how-many a (merge2 la lb))
         (+ (how-many a la) (how-many a lb))))

(defthm how-many-split
  (equal (+ (how-many a (car (split-list lst)))
            (how-many a (mv-nth 1 (split-list lst))))
         (how-many a lst)))

;Subgoal *1/3.1'
;(IMPLIES
;  (AND (CONSP LST)
;       (CONSP (CDR LST))
;       (NOT (EQUAL E (CAR LST)))
;       (EQUAL (HOW-MANY E
;                        (MERGESORT (CONS (CAR LST)
;                                         (MV-NTH 1 (SPLIT-LIST (CDR LST))))))
;              (HOW-MANY E (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;       (EQUAL (HOW-MANY E
;                        (MERGESORT (CAR (SPLIT-LIST (CDR LST)))))
;              (HOW-MANY E (CAR (SPLIT-LIST (CDR LST))))))
;  (EQUAL
;       (HOW-MANY E
;                 (MERGE2 (MERGESORT (CONS (CAR LST)
;                                          (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;                         (MERGESORT (CAR (SPLIT-LIST (CDR LST))))))
;       (HOW-MANY E (CDR LST))))
;
; [JM] It seem the same thing with subgoal *1/3.2'

; Proof target
(defthm how-many-equal-after-mergesort
  (equal (how-many e (mergesort lst))
         (how-many e lst)))


;;; Exercise 11.49
; Copy from 11.5
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

(defthm counterexample-49
  (equal
   (let ((a '(1 2))
         (b '(1 3))
         (e 1))
     (iff (perm a b)
          (equal (how-many e a)
                 (how-many e b))))
   nil)
  :rule-classes nil)


;;; Exercise 11.50
(encapsulate
 ((alpha () t)
  (beta  () t))

 (local (defun alpha () nil))

 (local (defun beta () nil))

 (defthm how-many-is-same-for-a-and-b
   (equal (how-many e (alpha))
          (how-many e (beta))))
 )

; [JM] Skip this theorem proof
(skip-proofs
 (defthm perm-alpha-beta
   (perm (alpha) (beta))))

;;; Exercise 11.51

; Proof target
(defthm perm-mergesort
  (perm (mergesort lst) lst)
  :hints (("Goal" :use (:functional-instance
                        perm-alpha-beta
                        (alpha (lambda nil (mergesort lst)))
                        (beta (lambda nil lst))))))#|ACL2s-ToDo-Line|#


                  
