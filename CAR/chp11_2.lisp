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
; [JM] Since (in a (del b z) -> (in a z), this subgoal is a contradiction
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
; (DEFTHM PERM-IMPLIES-PERM-APPEND-1
;         (IMPLIES (PERM X X-EQUIV)
;                  (PERM (APPEND X Y) (APPEND X-EQUIV Y)))
;         :RULE-CLASSES (:CONGRUENCE))


;;; Exercise 11.7
; Proof helper

;(IMPLIES (AND (PERM (APPEND X2 Y) (APPEND DL Y))
;              (IN X1 X-EQUIV)
;              (PERM X2 DL))
;         (IN X1 (APPEND X-EQUIV Y))).
;^^^ Checkpoint *1.1 ^^^
; [JM] The prover starts to loop here, which is (in a x) -> (in a (append x y)
(defthm in-append
  (implies (in a x)
           (in a (append x y))))

; Proof target
(defcong perm perm (append x y) 1)

:trans1 (defcong perm perm (append x y) 2)
; (DEFTHM PERM-IMPLIES-PERM-APPEND-2
;         (IMPLIES (PERM Y Y-EQUIV)
;                  (PERM (APPEND X Y) (APPEND X Y-EQUIV)))
;         :RULE-CLASSES (:CONGRUENCE))

(defcong perm perm (append x y) 2)

;;; Exercise 11.8
(defun less (x lst)
  (cond ((endp lst) nil)
        ((< (car lst) x) (cons (car lst) (less x (cdr lst))))
        (t (less x (cdr lst)))))

;;; Exercise 11.9
(defun notless (x lst)
  (cond ((endp lst) nil)
        ((< (car lst) x) (notless x (cdr lst)))
        (t (cons (car lst) (notless x (cdr lst))))))

(defun qsort (x)
  (cond ((atom x) nil)
        (t (append (qsort (less (car x) (cdr x)))
                   (list (car x))
                   (qsort (notless (car x) (cdr x)))))))

;;; Exercise 11.10

; Proof helper
;Subgoal *1/2''
;(IMPLIES (AND (CONSP X)
;              (PERM (QSORT (LESS (CAR X) (CDR X)))
;                    (LESS (CAR X) (CDR X)))
;              (PERM (QSORT (NOTLESS (CAR X) (CDR X)))
;                    (NOTLESS (CAR X) (CDR X))))
;         (PERM (APPEND (LESS (CAR X) (CDR X))
;                       (CONS (CAR X)
;                             (NOTLESS (CAR X) (CDR X))))
;               X))

; From proof of perm-qsort-less
;(IMPLIES (AND (TRUE-LISTP LS)
;              (< A X1)
;              (PERM (QSORT LS) LS))
;         (PERM (QSORT (CONS X1 LS))
;               (CONS X1 LS))).
;^^^ Checkpoint *1.1 ^^^
; [JM] There is (perm (qsort x) x) in proposition, it seems a dead end
;(defthm perm-qsort-less
;  (perm (qsort (less a x))
;        (less a x)))
;
; [JM] back to subgoal *1/2'', (CAR X)=a, (CDR X)=d, we got,
;(defthm perm-less-notless
;  (perm (append (less a d)
;                (cons a (notless a d)))
;        (cons a d))
;
; From perm-less-notless
;Subgoal *1/3''
;(IMPLIES (AND (CONSP D)
;              (<= (CAR D) A)
;              (PERM (APPEND (LESS A (CDR D))
;                            (CONS A (NOTLESS A (CDR D))))
;                    (CDR D)))
;         (PERM (APPEND (LESS A (CDR D))
;                       (LIST* A (CAR D) (NOTLESS A (CDR D))))
;               D))
; [JM] let (LESS A (CDR D))= lst, (NOTLESS A (CDR D))= nlst, we got,
;(defthm perm-cons-append
;  (perm (cons a (append lst nlst))
;        (append lst (cons a nlst))))
;
; Use perm-reflexivity
(defthm perm-append-cons
  (perm (append lst (cons a nlst))
        (cons a (append lst nlst))))

(defthm perm-less-notless
  (perm (append (less a d)
                (cons a (notless a d)))
        (cons a d)))
   
; Proof target
(defthm perm-qsort
  (perm (qsort x) x))

 ;;; Exercise 11.11
(defun lessp (x lst)
  (cond ((endp lst) t)
        ((< (car lst) x) (lessp x (cdr lst)))
        (t nil)))
; Test lessp
(lessp 3 '(1 2 3))
(lessp 4 '(1 2 3))
  
 ;;; Exercise 11.12
(defun notlessp (x lst)
  (cond ((endp lst) t)
        ((< (car lst) x) nil)
        (t (notlessp x (cdr lst)))))
; Test notlessp
(notlessp 3 '(1 2 3))
(notlessp 2 '(1 2 3))
  
 ;;; Exercise 11.13
:trans1 (defcong perm equal (lessp x lst) 2)
; (DEFTHM PERM-IMPLIES-EQUAL-LESSP-2
;         (IMPLIES (PERM LST LST-EQUIV)
;                  (EQUAL (LESSP X LST)
;                         (LESSP X LST-EQUIV)))
;         :RULE-CLASSES (:CONGRUENCE))
(defcong perm equal (lessp x lst) 2)
(defcong perm equal (notlessp x lst) 2)

 ;;; Exercise 11.14
(defun orderedp (x)
  (cond ((atom (cdr x)) t)
        (t (and (<= (car x) (cadr x))
                (orderedp (cdr x))))))

;Subgoal *1/2''
;(IMPLIES (AND (CONSP LST)
;              (ORDEREDP (QSORT (LESS (CAR LST) (CDR LST))))
;              (ORDEREDP (QSORT (NOTLESS (CAR LST) (CDR LST)))))
;         (ORDEREDP (APPEND (QSORT (LESS (CAR LST) (CDR LST)))
;                           (CONS (CAR LST)
;                                 (QSORT (NOTLESS (CAR LST) (CDR LST)))))))
; [JM] let (QSORT (LESS (CAR LST) (CDR LST)))=X,
;          (QSORT (NOTLESS (CAR LST) (CDR LST)))=Y, we got
;(defthm orderedp-append
;  (implies (and (orderedp x)
;                (orderedp y)
;                (<= (car (last x)) (car y)))
;           (orderedp (append x y))))
; [JM] It seems not work, try stronger theorem
;(defthm orderedp-append
;  (equal (and (orderedp x)
;                (orderedp y)
;                (<= (car (last x)) (car y)))
;          (orderedp (append x y))))
; [JM] No idea the difference between the one in solution and above
(defthm orderedp-append
  (equal (orderedp (append x y))
         (if (consp x)
           (if (consp y)
             (and (orderedp x)
                   (orderedp y)
                   (<= (car (last x)) (car y)))
             (orderedp x))
           (orderedp y))))

; Proof target move on to
;Subgoal *1/2.2
;(IMPLIES (AND (CONSP LST)
;              (ORDEREDP (QSORT (LESS (CAR LST) (CDR LST))))
;              (ORDEREDP (QSORT (NOTLESS (CAR LST) (CDR LST))))
;              (CONSP (QSORT (NOTLESS (CAR LST) (CDR LST)))))
;         (<= (CAR LST)
;             (CAR (QSORT (NOTLESS (CAR LST) (CDR LST))))))
;
; [JM] From *1/2.2, it seem we need to proof
;      a <= car (notless a lst), while (notless a lst) cannot be nil
(defthm car-notless
  (implies (and (consp lst)
                (notlessp a lst))
           (<= a (car lst))))

; [JM] not work, no idea, from solution
(defthm qsort-notlessp
  (equal (notlessp a (qsort lst))
         (notlessp a lst)))

(defthm notlessp-notless
  (notlessp a (notless a lst)))

;Subgoal *1/2.1
;(IMPLIES (AND (CONSP LST)
;              (ORDEREDP (QSORT (LESS (CAR LST) (CDR LST))))
;              (ORDEREDP (QSORT (NOTLESS (CAR LST) (CDR LST))))
;              (CONSP (QSORT (LESS (CAR LST) (CDR LST)))))
;         (<= (CAR (LAST (QSORT (LESS (CAR LST) (CDR LST)))))
;             (CAR LST)))
;
; [JM] From *1/2.1, it seem we need to proof
;      car (last (less a lst)) <= a, while (less a lst) cannot be nil
(defthm car-less
  (implies (and (consp lst)
                (lessp a lst))
           (<= (car (last lst)) a)))

; [JM] not work, no idea, from solution
(defthm qsort-lessp
  (equal (lessp a (qsort lst))
         (lessp a lst)))

(defthm lessp-less
  (lessp a (less a lst)))
                
; Proof target
(defthm orderedp-qsort
  (orderedp (qsort lst)))

;;; Exercise 11.15
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

; [JM] define mergesort need to proof its measure, check the proof log
;Goal
;(AND (IMPLIES (AND (NOT (ENDP X))
;                   (NOT (ENDP (CDR X))))
;              (O< (ACL2-COUNT (MV-NTH 1 (SPLIT-LIST X)))
;                  (ACL2-COUNT X)))
;     (IMPLIES (AND (NOT (ENDP X))
;                   (NOT (ENDP (CDR X))))
;              (O< (ACL2-COUNT (MV-NTH 0 (SPLIT-LIST X)))
;                  (ACL2-COUNT X)))))
;Subgoal 2'
;(IMPLIES (AND (CONSP X) (CONSP (CDR X)))
;         (< (ACL2-COUNT (CAR (SPLIT-LIST (CDR X))))
;            (ACL2-COUNT X))
;Subgoal 1''
;(IMPLIES (AND (CONSP X) (CONSP (CDR X)))
;         (< (+ 1 (ACL2-COUNT (CAR X))
;               (ACL2-COUNT (MV-NTH 1 (SPLIT-LIST (CDR X)))))
;            (+ 1 (ACL2-COUNT (CAR X))
;               (ACL2-COUNT (CDR X)))))
;
; [JM] Make them as a theorem, and of course ACL2 cannot prove it
;(defthm measure-of-mergesort
;  (implies (and (consp x) (consp (cdr x)))
;           (and ;subgoal 1''
;                (< (acl2-count (mv-nth 1 (split-list x)))
;                   (acl2-count x))
;                ;subgoal 2'
;                (< (acl2-count (car (split-list (cdr x))))
;                   (acl2-count x)))))
; [JM] It seems both subgoals are saying one thing,
;      both length of (split-list x) is small than the orignal one.
;      Try theorem like the goal
;(defthm measure-of-mergesort
;  (and (implies (and (consp x) (consp (cdr x)))
;                ;subgoal 1''
;                (< (acl2-count (mv-nth 1 (split-list x)))
;                   (acl2-count x)))
;       (implies (and (consp x) (consp (cdr x)))
;                ;subgoal 2'
;                (< (acl2-count (mv-nth 0 (split-list x)))
;                   (acl2-count x)))))
(defthm measure-of-mergesort
  (and (implies (and (not (endp x))
                     (not (endp (cdr x))))
                (o< (acl2-count (mv-nth 1 (split-list x)))
                    (acl2-count x)))
       (implies (and (not (endp x))
                     (not (endp (cdr x))))
                (o< (acl2-count (mv-nth 0 (split-list x)))
                    (acl2-count x)))))
; [JM] The prover now make it, but still not work in mergesort(x)
;(defun mergesort (x)
;  (cond ((endp x) nil)
;        ((endp (cdr x)) x)
;        (t (mv-let (odds evens)
;                   (split-list x)
;                   (merge2 (mergesort odds) (mergesort evens))))))
;
; [JM] Maybe only need to measure the len of x,
;      Add (declare (xargs :measure (acl2-count x))) to mergesort, gets the same subgoals
;      Add hints to let the prover smarter
(defun mergesort (x)
  (declare (xargs :measure (acl2-count x)
                  :hints (("Goal" :use measure-of-mergesort))
                  ))
  (cond ((endp x) nil)
        ((endp (cdr x)) x)
        (t (mv-let (odds evens)
                   (split-list x)
                   (merge2 (mergesort odds) (mergesort evens))))))

; Proof target
(defthm orderedp-mergesort
  (orderedp (mergesort lst)))

;;; Exercise 11.16
;Subgoal *1/3'''
;(IMPLIES (AND (CONSP LST)
;              (CONSP (CDR LST))
;              (PERM (MERGESORT (CONS (CAR LST)
;                                     (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;                    (CONS (CAR LST)
;                          (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;              (PERM (MERGESORT (CAR (SPLIT-LIST (CDR LST))))
;                    (CAR (SPLIT-LIST (CDR LST)))))
;         (PERM (MERGE2 (MERGESORT (CONS (CAR LST)
;                                        (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;                       (MERGESORT (CAR (SPLIT-LIST (CDR LST)))))
;               LST))
; [JM] It seem merge2 keeps perm with append two list, try merge2-append
;Subgoal *1/4.2
;(IMPLIES (AND (CONSP X)
;              (CONSP Y)
;              (<= (CAR Y) (CAR X))
;              (PERM (MERGE2 X (CDR Y))
;                    (APPEND X (CDR Y))))
;         (IN (CAR Y) (APPEND X Y)))
;
;Subgoal *1/4.1
;(IMPLIES (AND (CONSP X)
;              (CONSP Y)
;              (<= (CAR Y) (CAR X))
;              (PERM (MERGE2 X (CDR Y))
;                    (APPEND X (CDR Y))))
;         (PERM (APPEND X (CDR Y))
;               (DEL (CAR Y) (APPEND X Y))))
;
; Proof helper of merge2-append
; [JM] From *1/4.2, try car-in-append
(defthm car-in-append
  (implies (consp y)
           (in (car y) (append x y))))

; [JM] From *1/4.1, try first version of perm-append-del
;(defthm perm-append-del-v1
;  (implies (and (consp x)
;                (consp y)
;                (perm (merge2 x (cdr y))
;                      (append x (cdr y))))
;           (perm (append x (cdr y))
;                 (del (car y) (append x y)))))
;
; [JM] It seems *v1 will never be true if (in a x), from prover
;Subgoal *1/2.1
;(IMPLIES (AND (CONSP X)
;              (NOT (PERM (MERGE2 (CDR X) (CDR Y))
;                         (APPEND (CDR X) (CDR Y))))
;              (CONSP Y)
;              (PERM (MERGE2 X (CDR Y))
;                    (CONS (CAR X) (APPEND (CDR X) (CDR Y))))
;              (NOT (EQUAL (CAR Y) (CAR X))))
;         (PERM (MERGE2 X (CDR Y))
;               (CONS (CAR X)
;                     (DEL (CAR Y) (APPEND (CDR X) Y)))))
;
; [JM] Try to add (not (in (car y) x)) in the theorem                        
;(defthm perm-append-del-v2
;  (implies (and (consp x)
;                (consp y)
;                (not (in (car y) x)))
;           (perm (append x (cdr y))
;                 (del (car y) (append x y)))))
;
; [JM] *v2 is admited, but it do not help to proof merge2-append,
;      the prover do not know how to use it.
;
; [JM] Look back *1/4.1, try a stronger version
;Subgoal *1/2.4'
;(IMPLIES (AND (CONSP X)
;              (PERM (APPEND (CDR X) (CDR Y))
;                    (DEL (CAR X) (APPEND (CDR X) Y)))
;              (CONSP Y)
;              (EQUAL (CAR Y) (CAR X)))
;         (IN (CAR X) (APPEND (CDR X) Y)))
;
; [JM] Try equal-in-append
(defthm equal-in-append
  (implies (and (consp x)
                (consp y)
                (equal (car y) (car x)))
           (in (car x) (append (cdr x) y))))
                
                       
(defthm perm-append-del
  (implies (and (consp x)
                (consp y))
           (perm (append x (cdr y))
                 (del (car y) (append x y)))))

           
(defthm merge2-append
  (perm (merge2 x y)
        (append x y))
  :hints (("Goal" :induct (merge2 x y))))

;Subgoal *1/3'''
;(IMPLIES (AND (CONSP LST)
;              (CONSP (CDR LST))
;              (PERM (MERGESORT (CONS (CAR LST)
;                                     (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;                    (CONS (CAR LST)
;                          (MV-NTH 1 (SPLIT-LIST (CDR LST)))))
;              (PERM (MERGESORT (CAR (SPLIT-LIST (CDR LST))))
;                    (CAR (SPLIT-LIST (CDR LST)))))
;         (PERM (APPEND (MV-NTH 1 (SPLIT-LIST (CDR LST)))
;                       (CAR (SPLIT-LIST (CDR LST))))
;               (CDR LST)))
;
; [JM] Subgoal pass merge2, and move on, try perm-append-split and got
;Subgoal *1/3''
;(IMPLIES (AND (CONSP LST)
;              (PERM (APPEND (CAR (SPLIT-LIST (CDR LST)))
;                            (MV-NTH 1 (SPLIT-LIST (CDR LST))))
;                    (CDR LST)))
;         (PERM (APPEND (MV-NTH 1 (SPLIT-LIST (CDR LST)))
;                       (CAR (SPLIT-LIST (CDR LST))))
;               (CDR LST)))
; [JM] It seems a dead loop proof, 
;      and need to proof a theorem that append keeps perm property 
(defthm perm-append
  (perm (append x y)
        (append y x)))

(defthm perm-append-split
  (implies (consp lst)
           (perm (append (mv-nth 1 (split-list lst))
                         (car (split-list lst)))
                 lst)))
 
(defthm perm-append-split-rev
  (implies (consp lst)
           (perm (append (car (split-list lst))
                         (mv-nth 1 (split-list lst)))
                 lst)))



; Proof target
(defthm perm-mergesort
  (perm (mergesort lst) lst))#|ACL2s-ToDo-Line|#




  
  


