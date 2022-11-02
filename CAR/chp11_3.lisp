;;; Exercise 11.17
(defun in (a b)
  (cond ((atom b) nil)
        ((equal a (car b)) t)
        (t (in a (cdr b)))))

; [JM] My compress define
(defun compress (x)
  (cond ((endp x) nil)
        ((equal (car x) (cadr x)) (compress (cdr x)))
        (t (cons (car x) (compress (cdr x))))))

; [JM] Define from solution
(defun compress-s (x)
  (cond ((or (endp x) (endp (cdr x))) x)
        ((equal (car x) (cadr x)) (compress (cdr x)))
        (t (cons (car x) (compress (cdr x))))))

; Try to fine the difference
;(defthm compress-equiv
;  (equal (compress x) (compress-s x)))

; Test compress
(compress '(x x x y z y x y y))
; It should be '(x y z y x y)
(compress '(x x x y z z z y x y y))
; It should be '(x y z y x y)
(compress '())
(compress '(x))
(compress '(x x))
(compress '(nil x x))
(compress-s '(nil x x))
(cadr '())#|ACL2s-ToDo-Line|#




;;; Exercise 11.18
(defthm compress-compress
  (equal (compress (compress x)) (compress x)))


;;; Exercise 11.19

; Proof helper
; [JM] Proof of compress-append, from prover 
;Subgoal *1/2.3'
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS (APPEND (COMPRESS (CDR X)) Y))
;                     (COMPRESS (APPEND (CDR X) Y)))
;              (EQUAL (CAR X) (CADR X)))
;         (EQUAL (CAR X)
;                (CAR (APPEND (CDR X) Y))))
; 
; [JM] Try car-append
;(defthm car-append
;  (implies (equal a (car x))
;           (equal a (car (append x y)))))
(defthm car-append
  (equal (car (append x y))
         (if (consp x)
             (car x)
           (car y))))

(and (not (car '(x)))
     (consp '(x)))
(defthm consp-compress
  (equal (consp (compress x))
         (consp x)))                
; Proof target
(defthm compress-append
  (equal (compress (append (compress x) y))
         (compress (append x y))))

;;; Exercise 11.20
(defun orderedp (x)
  (cond ((atom (cdr x)) t)
        (t (and (<= (car x) (cadr x))
                (orderedp (cdr x))))))

(defun mem (e x)
  (if (endp x)
    nil
    (if (equal e (car x))
      t
      (mem e (cdr x)))))

; [JM] mem is similar with in, try to replace it
(defun no-dupls-p (lst)
  (cond ((atom lst) t)
        ((in (car lst) (cdr lst)) nil)
        (t (no-dupls-p (cdr lst)))))
; Test no-dupls-p
(no-dupls-p '(a b c a d))
(no-dupls-p '(a b c d))
            
; Proof helper for compress-orderedp
;Subgoal *1/5.1
;(IMPLIES (AND (CONSP X)
;              (NOT (IN (CAR X) (CDR X)))
;              (NO-DUPLS-P (COMPRESS (CDR X)))
;              (<= (CAR X) (CADR X))
;              (ORDEREDP (CDR X)))
;         (NOT (IN (CAR X) (COMPRESS (CDR X)))))
;
; [JM] It seems it need not-in-compress
(defthm not-in-compress
  (implies (not (in a x))
           (not (in a (compress x)))))


; Proof target
(defthm compress-ordered
  (implies (orderedp x)
           (no-dupls-p (compress x))))


;;; Exercise 11.21
(defun same-compress (x y)
  (equal (compress x) (compress y)))

;;; Exercise 11.22
:trans1 (defequiv same-compress)
; (DEFTHM SAME-COMPRESS-IS-AN-EQUIVALENCE
;         (AND (BOOLEANP (SAME-COMPRESS X Y))
;              (SAME-COMPRESS X X)
;              (IMPLIES (SAME-COMPRESS X Y)
;                       (SAME-COMPRESS Y X))
;              (IMPLIES (AND (SAME-COMPRESS X Y)
;                            (SAME-COMPRESS Y Z))
;                       (SAME-COMPRESS X Z)))
;         :RULE-CLASSES (:EQUIVALENCE))
(defequiv same-compress)

;;; Exercise 11.23
:trans1 (defcong same-compress same-compress (append x y) 2)
; (DEFTHM SAME-COMPRESS-IMPLIES-SAME-COMPRESS-APPEND-2
;         (IMPLIES (SAME-COMPRESS Y Y-EQUIV)
;                  (SAME-COMPRESS (APPEND X Y)
;                                 (APPEND X Y-EQUIV)))
;         :RULE-CLASSES (:CONGRUENCE))

; Proof helper
; [JM] Try to proof (defcong same-compress same-compress (append x y) 2),
;      from prover
;Subgoal *1/2.2'
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS (APPEND (CDR X) Y))
;                     (COMPRESS (APPEND (CDR X) Y-EQUIV)))
;              (EQUAL (COMPRESS Y) (COMPRESS Y-EQUIV))
;              (IN (CAR X) (APPEND (CDR X) Y)))
;         (IN (CAR X) (APPEND (CDR X) Y-EQUIV)))
;
; [JM] It seems the prover need in-equal-compress-append, from prover
;Subgoal *1/2.1
;(IMPLIES (AND (CONSP Y)
;              (NOT (IN (CAR Y) (CDR Y)))
;              (EQUAL (CONS (CAR Y) (COMPRESS (CDR Y)))
;                     (COMPRESS Y-EQUIV)))
;         (IN (CAR Y) Y-EQUIV))
;
; [JM] Add equal-cons-compress-in
(defthm equal-cons-in
  (implies (equal (cons a (compress x)) (compress y))
           (in a y)))

; [JM] The proof of in-equal-compress-append move on to
;Subgoal *1/1''
;(IMPLIES (AND (NOT (CONSP X))
;              (EQUAL (COMPRESS Y) (COMPRESS Y-EQUIV))
;              (IN A Y))
;         (IN A Y-EQUIV))
;
; [JM] Try equal-compress-in, from prover
;Subgoal *1/3.1'
;(IMPLIES (AND (CONSP Y)
;              (NOT (EQUAL A (CAR Y)))
;              (NOT (EQUAL (COMPRESS (CDR Y))
;                          (COMPRESS Y-EQUIV)))
;              (NOT (IN (CAR Y) (CDR Y)))
;              (EQUAL (CONS (CAR Y) (COMPRESS (CDR Y)))
;                     (COMPRESS Y-EQUIV))
;              (IN A (CDR Y)))
;         (IN A Y-EQUIV))
;
;

(defthm equal-compress-in
  (implies (and (equal (compress y) (compress y-equiv))
                (in a y))
           (in a y-equiv)))
                
(defthm in-equal-compress-append
  (implies (and (equal (compress y) (compress y-equiv))
                (in a (append x y)))
           (in a (append x y-equiv))))



                
;Subgoal *1/2.1'
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS (APPEND (CDR X) Y))
;                     (COMPRESS (APPEND (CDR X) Y-EQUIV)))
;              (EQUAL (COMPRESS Y) (COMPRESS Y-EQUIV))
;              (NOT (IN (CAR X) (APPEND (CDR X) Y))))
;         (NOT (IN (CAR X) (APPEND (CDR X) Y-EQUIV))))
;
; Proof target
(defcong same-compress same-compress (append x y) 2)

; Backup
(defthm in-compress
  (equal (in a (compress x))
         (in a x)))
