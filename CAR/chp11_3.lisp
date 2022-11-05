;;; Exercise 11.17
(defun in (a b)
  (cond ((atom b) nil)
        ((equal a (car b)) t)
        (t (in a (cdr b)))))

; [JM] My compress define
(defun compress-jm (x)
  (cond ((endp x) nil)
        ((equal (car x) (cadr x)) (compress-jm (cdr x)))
        (t (cons (car x) (compress-jm (cdr x))))))

; [JM] Define from solution
(defun compress-s (x)
  (cond ((or (endp x) (endp (cdr x))) x)
        ((equal (car x) (cadr x)) (compress-s (cdr x)))
        (t (cons (car x) (compress-s (cdr x))))))

; Test compress
(compress-jm '(x x x y z y x y y))
(compress-jm '(x x x y z z z y x y y))
(compress-jm '())
(compress-jm '(x))
(compress-jm '(x x))
(compress-jm '(nil x))
(compress-s  '(nil x))
(compress-jm '(nil nil))
(compress-s  '(nil nil))
; [JM] Try to find the difference with theorem compress-equiv, and get
;(defthm compress-equiv
;  (equal (compress-jm x) (compress-s x)))
;Subgoal *1/2.2''
;(IMPLIES (AND (CONSP X) (NOT (CAR X)))
;         (CDR X))
(and (consp '(nil)) (not (car '(nil)))); return T
(cdr '(nil)); return NIL
; [JM] Maybe compress is not equal to compress-s with '(nil)
(compress-jm '(nil))
(compress-s '(nil))
(endp '(nil)) ; return NIL
(equal (car '(nil)) (cadr '(nil))) ; returns T, here is the problem

; [JM] Try a new version compress-jm2
(defun compress-jm2 (x)
  (cond ((endp x) nil)
        ((endp (cdr x)) x)
        ((equal (car x) (cadr x)) (compress-jm2 (cdr x)))
        (t (cons (car x) (compress-jm2 (cdr x))))))
;Test compress
(compress-jm2 '(nil))
(compress-jm2 '())
(compress-s '(nil))
(compress-s'())

;Subgoal *1/1.2
;(IMPLIES (NOT (CONSP X)) (NOT X))
(not (consp t))
(not t)
;(defthm compress-equiv
;  (equal (compress-jm2 x) (compress-s x)))

(defun compress (x)
  (cond ((endp x) x)
        ((endp (cdr x)) x)
        ((equal (car x) (cadr x)) (compress (cdr x)))
        (t (cons (car x) (compress (cdr x))))))


;;; Exercise 11.18
; Proof helper of compress-compress
;Subgoal *1/4'''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (EQUAL (COMPRESS (COMPRESS (CDR X)))
;                     (COMPRESS (CDR X)))
;              (CONSP (COMPRESS (CDR X))))
;         (NOT (EQUAL (CAR X)
;                     (CAR (COMPRESS (CDR X))))))
; [JM] try not-equal-car-compress
(defthm not-equal-car-compress
  (implies (and (consp x)
                (not (equal a (car x))))
           (not (equal a
                       (car (compress x))))))

; Proof target
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
  (cond ((endp lst) t)
        ((in (car lst) (cdr lst)) nil)
        (t (no-dupls-p (cdr lst)))))
; Test no-dupls-p
(no-dupls-p '(a b c a d))
(no-dupls-p '(a b c d))
            
; Proof helper for compress-orderedp
;Subgoal *1/6''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (NO-DUPLS-P (COMPRESS (CDR X)))
;              (<= (CAR X) (CADR X))
;              (ORDEREDP (CDR X)))
;         (NOT (IN (CAR X) (COMPRESS (CDR X)))))
;
; [JM] Try not-equal-car-not-in-compress, from prover
;Subgoal *1/4.2'
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (<= (CADR X) (CAR X))
;              (<= (CAR X) (CADR X))
;              (ORDEREDP (CDR X)))
;         (NOT (IN (CADR X) (COMPRESS (CDR X)))))
;
; [JM] (NOT (IN (CADR X) (COMPRESS (CDR X))))) can never be true
;      Maybe not-equal-car-not-in-compress is a contradiction
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (<= (CADR X) (CAR X))
;              (<= (CAR X) (CADR X))
; [JM] These three propositions is contraditon, try asset it with less-equal-equal,
;      from prover 
;Subgoal 3
;(IMPLIES (AND (NOT (EQUAL A B)) (<= A B))
;         (< A B))
; [JM] It seems easy, but can never be proof, drop less-equal-equal
;(defthm less-equal-equal
;  (equal  (and (<= a b)
;               (<= b a))
;           (equal a b)))
;              
;           
;(defthm not-equal-car-not-in-compress
;  (implies (and (consp x)
;                (not (equal a (car x)))
;                (<= a (car x))
;                (orderedp x))
;           (not (in a (compress x)))))
;
; [JM] Try car-in-compress, not help
(defthm car-in-compress
  (implies (consp x)
           (in (car x) (compress x))))
; [JM] Try something about (in a (compress x))
(defthm in-compress
  (equal (in a (compress x))
         (in a x)))

; [JM] Not come across subgoal suggests this, from solution
(defun number-listp (x)
  (if (endp x)
      t
    (and (acl2-numberp (car x))
         (number-listp (cdr x)))))


; Proof target
(defthm ordered-compress-is-no-dupls-p
  (implies (and (orderedp x)
                (number-listp x))
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
;Subgoal *1/2.4'
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS Y) (COMPRESS Y-EQUIV))
;              (CONSP Y)
;              (NOT (CONSP (CDR X)))
;              (NOT (EQUAL (CAR X) (CAR Y)))
;              (CONSP Y-EQUIV))
;         (NOT (EQUAL (CAR X) (CAR Y-EQUIV))))
;
; [JM] It seems the prover need same-compress-car-equal,
;      open gag-mode for more prove detail
:set-gag-mode nil
;
; [JM] Since prover complains (same-compress x y) with doubld-rewrite,
;      Rewrite same-compress with its defun, From prover
;Subgoal *1/4.2'
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (NOT (EQUAL (COMPRESS (CDR X)) (COMPRESS Y)))
;              (CONSP Y)
;              (EQUAL (CONS (CAR X) (COMPRESS (CDR X)))
;                     (COMPRESS Y)))
;         (EQUAL (CAR X) (CAR Y)))
;
; [JM] It seems just need the last hypothesis can prove subgoal.
;      Try equal-compress-car, :REWRITE rule illegal
;(defthm equal-compress-car
;  (implies (equal (cons a x)
;                  (compress y))
;           (equal a (car y))))
; [JM] Rewrite it without a
(defthm car-compress
  (equal (car (compress x))
         (car x)))

:brr t
(cw-gstack :frames 30)
(defthm same-compress-car-equal
  (implies (and (consp x)
                (consp y)
                (equal (compress x) (compress y)))
           (equal (car x) (car y)))
  :hints (("Goal"
           :use (car-compress
                 (:instance car-compress (x y)))
           :in-theory (disable car-compress)))
  :rule-classes :forward-chaining)

(cw-gstack :frames 30)
; [JM] Prover rewrite limit exceeded with same-compress-car-equal
;      Try hints, subgoal *1/2.4' not known to use same-compress-car-equal, not work
;(defcong same-compress same-compress (append x y) 2
;  :hints (("Goal"
;           :use (same-compress-car-equal
;                 (:instance same-compress-car-equal
;                  (x y)
;                  (y y-equiv)))
;           :in-theory (disable same-compress-car-equal))))
;
; [JM] From solution, add :rule-classes in same-compress-car-equal
; Proof target
(defcong same-compress same-compress (append x y) 2)

;;; Exercise 11.24
:trans1 (defcong same-compress same-compress (append x y) 1)
; (DEFTHM SAME-COMPRESS-IMPLIES-SAME-COMPRESS-APPEND-1
;         (IMPLIES (SAME-COMPRESS X X-EQUIV)
;                  (SAME-COMPRESS (APPEND X Y)
;                                 (APPEND X-EQUIV Y)))
;         :RULE-CLASSES (:CONGRUENCE))

; Proof target
(defcong same-compress same-compress (append x y) 1
  :hints (("Goal"
          :use (compress-append
                (:instance compress-append (x x-equiv)))
          :in-theory (disable compress-append))))

;;; Exercise 11.25
(defun app (x y)
  (if (endp x)
    y
    (cons (car x)
          (app (cdr x) y))))

(defun rev (x)
 (if (endp x)
   nil
   (app (rev (cdr x)) (list (car x)))))

;Proof helper for equal-rev-compress
;Subgoal *1/4''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (EQUAL (REV (COMPRESS (CDR X)))
;                     (COMPRESS (REV (CDR X)))))
;         (EQUAL (APP (COMPRESS (REV (CDR X)))
;                     (LIST (CAR X)))
;                (COMPRESS (APP (REV (CDR X)) (LIST (CAR X))))))
;
; [JM] Try car-not-equal-app-compress, from prover
;Subgoal *1/2.2
;(IMPLIES (AND (CONSP X)
;              (EQUAL (APP (COMPRESS (REV (CDR X))) (LIST A))
;                     (COMPRESS (APP (REV (CDR X)) (LIST A))))
;              (CONSP (CDR X))
;              (NOT (EQUAL A (CAR X))))
;         (EQUAL (APP (COMPRESS (APP (REV (CDR X)) (LIST (CAR X))))
;                     (LIST A))
;                (COMPRESS (APP (APP (REV (CDR X)) (LIST (CAR X)))
;                               (LIST A)))))
;
;Subgoal *1/2.1'
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CADR X) (CAR X))))
;         (EQUAL (APP (COMPRESS (APP (REV (CDR X)) (LIST (CAR X))))
;                     (LIST (CADR X)))
;                (COMPRESS (APP (APP (REV (CDR X)) (LIST (CAR X)))
;                               (LIST (CADR X))))))
;
; [JM] Not much progress, try a simpler case without rev, last-not-equal-app-compress
;      From prover
;Subgoal *1/2.2''
;(IMPLIES (AND (CONSP X) (NOT (CONSP (CDR X))))
;         (EQUAL (CAR X) X))
;
; [JM] it seem this subgoal will never be true, since
;(let ((x '(nil)))
;  (implies (and (consp x) (not (consp (cdr x))))
;           (equal (car x) x)))
;> NIL
;(let ((x '(1)))
;  (implies (and (consp x) (not (consp (cdr x))))
;           (equal (car x) x)))
;> NIL
;
; [JM] What do I miss here? try add (consp (cdr x)), mask
;(defthm last-not-equal-app-compress
;  (implies (and (consp x)
;                (not (equal a (last x))))
;           (equal (app (compress x) (list a))
;                  (compress (app x (list a))))))
;Subgoal *1/4.2''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (NOT (CONSP (CDDR X))))
;         (EQUAL (CADR X) (CDR X)))
;
; [JM] It seem hard to proof subgoal *1/4.2''
;      Try to proof (car (last x)) is (car (rev x) first
;      It seems car-last-rev is easier
(defthm car-last-rev
  (implies (consp x)
           (equal (car (last (rev x)))
                  (car x))))

;(defthm rev-app
;  (implies (consp x)
;           (equal (app (rev (cdr x)) (list (car x)))
;                  (rev x))))
;
;
; [JM] Then I notice 3nd hypothesis is missing car
(defthm last-not-equal-app-compress
  (implies (and (consp x)
                (consp (cdr x))
                (not (equal a (car (last x)))))
           (equal (app (compress x) (list a))
                  (compress (app x (list a))))))

; [JM] Prover do not know use car-last-rev, it still need car-last-car-rev
;Subgoal *1/2''
;(IMPLIES (AND (CONSP (CDR X))
;              (EQUAL (CAR (REV (CDR X)))
;                     (CAR (LAST (CDR X))))
;              (CONSP X))
;         (EQUAL (CAR (APP (REV (CDR X)) (LIST (CAR X))))
;                (CAR (LAST (CDR X)))))
;
; [JM] Try to expand (last (rev x)) here, rev-rev
;(defthm rev-rev
;  (implies (consp x)
;           (equal (rev (rev x))
;                  x)))
;
;(defthm car-last-car-rev
;  (implies (consp x)
;           (equal (car (rev x))
;                  (car (last x)))))
          
;(defthm car-not-equal-app-compress
;  (implies (and (consp x)
;                (consp (cdr x))
;                (not (equal a (car x))))
;           (equal (app (compress (rev x)) (list a))
;                  (compress (app (rev x) (list a)))))
;  :hints (("Subgoal *1/2.2"
;           :use (car-last-rev
;                 rev-app
;                 last-not-equal-app-compress)
;           :in-theory (disable car-last-rev
;                               rev-app
;                               last-not-equal-app-compress)
;           )))
                       
;Subgoal *1/3''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (EQUAL (CAR X) (CADR X))
;              (EQUAL (REV (COMPRESS (CDR X)))
;                     (COMPRESS (REV (CDR X)))))
;         (EQUAL (COMPRESS (REV (CDR X)))
;                (COMPRESS (APP (REV (CDR X)) (LIST (CAR X))))))

; ============================================================================
; [JM] After above, from the prover
;Subgoal *1/4''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (NOT (EQUAL (CAR X) (CADR X)))
;              (EQUAL (REV (COMPRESS (CDR X)))
;                     (COMPRESS (REV (CDR X)))))
;         (EQUAL (APP (COMPRESS (REV (CDR X)))
;                     (LIST (CAR X)))
;                (COMPRESS (APP (REV (CDR X)) (LIST (CAR X))))))
;
;Subgoal *1/3''
;(IMPLIES (AND (CONSP X)
;              (CONSP (CDR X))
;              (EQUAL (CAR X) (CADR X))
;              (EQUAL (REV (COMPRESS (CDR X)))
;                     (COMPRESS (REV (CDR X)))))
;         (EQUAL (COMPRESS (REV (CDR X)))
;                (COMPRESS (APP (REV (CDR X)) (LIST (CAR X))))))
;
; [JM] It seems no help for subgoal *1/4''
;      From solution, it take both subgoals together and got
(defthm compress-app-atom
  (equal (compress (app x (list a)))
         (if (and (consp x)
                  (equal (car (last x)) a))
           (app (compress x) nil)
           (app (compress x) (list a)))))

:set-gag-mode t
; [JM] The prover do not stop with rewrite compress-app-atom
;      Interrupt the prover, and try to add some simplify rewrite rules
;      From solution
(defthm true-listp-rev
  (true-listp (rev x))
  ;; might as well make it a type-prescription rule
  :rule-classes :type-prescription)

(defthm true-listp-compress
  (equal (true-listp (compress x))
         (true-listp x)))

(defthm app-to-nil
  (implies (true-listp x)
           (equal (app x nil) x)))
;Proof target
(defthm equal-rev-compress
  (equal (rev (compress x))
         (compress (rev x))))#|ACL2s-ToDo-Line|#

                
                
