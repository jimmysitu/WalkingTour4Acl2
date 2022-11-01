;;; Exercise 11.17
(defun in (a b)
  (cond ((atom b) nil)
        ((equal a (car b)) t)
        (t (in a (cdr b)))))

(defun compress (x)
  (cond ((endp x) nil)
        ((in (car x) (cdr x)) (compress (cdr x)))
        (t (cons (car x) (compress (cdr x))))))

;;; Exercise 11.18
(defthm compress-compress
  (equal (compress (compress x)) (compress x)))


;;; Exercise 11.19

; Proof helper
;Subgoal *1/2.3'
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS (APPEND (COMPRESS (CDR X)) Y))
;                     (COMPRESS (APPEND (CDR X) Y)))
;              (IN (CAR X) (CDR X)))
;         (IN (CAR X) (APPEND (CDR X) Y)))
;
;[JM] It seems it needs in-apppend
(defthm in-append
  (implies (in a x)
           (in a (append x y))))

;Subgoal *1/2.2''
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS (APPEND (COMPRESS (CDR X)) Y))
;                     (COMPRESS (APPEND (CDR X) Y)))
;              (NOT (IN (CAR X) (CDR X)))
;              (NOT (IN (CAR X) (APPEND (CDR X) Y))))
;         (NOT (IN (CAR X)
;                  (APPEND (COMPRESS (CDR X)) Y))))
;
;[JM] It seems it needs not-in-append-compress
(defthm not-in-compress
  (implies (and (not (in a x))
                (not (in a (append x y))))
           (not (in a (append (compress x) y)))))

;Subgoal *1/2.1''
;(IMPLIES (AND (CONSP X)
;              (EQUAL (COMPRESS (APPEND (COMPRESS (CDR X)) Y))
;                     (COMPRESS (APPEND (CDR X) Y)))
;              (NOT (IN (CAR X) (CDR X)))
;              (IN (CAR X) (APPEND (CDR X) Y)))
;         (IN (CAR X)
;             (APPEND (COMPRESS (CDR X)) Y)))
;
;[JM] It seems it need in-append-compress
(defthm in-compress
  (implies (in a (append x y))
           (in a (append (compress x) y))))

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

(defun no-dupls-p (lst)
  (cond ((atom lst) t)
        ((mem (car lst) (cdr lst)) nil)
        (t (no-dupls-p (cdr lst)))))#|ACL2s-ToDo-Line|#


; Proof helper for compress-orderedp
;Subgoal *1/5.1
;(IMPLIES (AND (CONSP X)
;              (NOT (IN (CAR X) (CDR X)))
;              (NO-DUPLS-P (COMPRESS (CDR X)))
;              (<= (CAR X) (CADR X))
;              (ORDEREDP (CDR X)))
;         (NOT (MEM (CAR X) (COMPRESS (CDR X)))))


; Proof target
(defthm compress-ordered
  (implies (orderedp x)
           (no-dupls-p (compress x))))






