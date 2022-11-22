; [JM] From solution, exercises of this section need this book
(in-package "ACL2")
(include-book "ordinals/e0-ordinal" :dir :system)
(set-well-founded-relation e0-ord-<)


(defun ifp (x)
  (and (consp x)
       (equal (car x) 'if)))

(defun test (x)
  (second x))

(defun tb (x)
  (third x))

(defun fb (x)
  (fourth x))

;;; Exercise 11.34
(defun if-exprp (x)
  (cond ((ifp x) (and (true-listp x)
                      (equal (len x) 4)
                      (if-exprp (test x))
                      (if-exprp (tb x))
                      (if-exprp (fb x))))
        (t (atom x))))

:program                                
(defun if-n (x)
  (if (ifp x)
    (let ((test (test x))
          (tb (tb x))
          (fb (fb x)))
      (if (ifp test)
        (if-n (list 'if (test test)
                    (list 'if (tb test) tb fb)
                    (list 'if (fb test) tb fb)))
        (list 'if test (if-n tb) (if-n fb))))
    x))

;;; Exercise 11.35
(if-n '(if (if (if a b c) d e) e b))
; Return from ACL2
;(IF A (IF B (IF D E B) (IF E E B))
;    (IF C (IF D E B) (IF E E B)))


;;; Exercise 11.36
:logic

(include-book "arithmetic/top" :dir :system)

; [JM] Measure helper from solution
(defun if-depth (x)
  (if (ifp x)
      (+ 1 (if-depth (test x)))
    0))

(defun if-complexity (x)
  (if (ifp x)
      (* (if-complexity (test x))
         (+ (if-complexity (tb x))
            (if-complexity (fb x))))
    1))

(defun if-n (x)
  (declare (xargs :measure
                  (cons (+ 1 (if-complexity x))
                        (if-depth x))))
  (if (ifp x)
    (let ((test (test x))
          (tb (tb x))
          (fb (fb x)))
      (if (ifp test)
        (if-n (list 'if (test test)
                    (list 'if (tb test) tb fb)
                    (list 'if (fb test) tb fb)))
        (list 'if test (if-n tb) (if-n fb))))
    x))

;;; Exercise 11.37
; [JM] Think of,
;          (if-n '(if (if a b c) d e))
;      So that,
;           (test x) = '(if a b c)
;           (tb x) = d
;           (fb x) = e
;      1st round recursive, since (ifp (test x) is t,
;          (if-n ('if (test '(if a b c)
;                     ('if (tb '(if a b c)) d e)
;                     ('if (fb '(if a b c)) d e))))
;      and
;         ('if '(if a b c) (if-n d) (if-n e))
; [JM] Take meaure size of x function as (msize x), get
;      (1 + (msize (test x) + (msize ('if (tb '(if a b c)) d e))
;                             (msize ('if (fb '(if a b c)) d e))
;      and 
;          (msize (tb x)), (msize (fb x))
; [JM] It seem each round, size of input is larger, not sure how to proof termination
; Form solution
(defun natm (x)
  (if (ifp x)
    (+ (* 2 (natm (test x)))
       (* (natm (test x))
          (+ (natm (tb x)) (natm (fb x)))))
    1))

(defun if-n1 (x)
  (declare (xargs :measure (natm x)))
  (if (ifp x)
    (let ((test (test x))
          (tb (tb x))
          (fb (fb x)))
      (if (ifp test)
        (if-n1 (list 'if (test test)
                    (list 'if (tb test) tb fb)
                    (list 'if (fb test) tb fb)))
        (list 'if test (if-n1 tb) (if-n1 fb))))
    x))

;;; Exercise 11.38
(defun aeval (x a)
  (if (booleanp x)
    x
    (cdr (assoc x a))))

(defun peval (x a)
  (if (ifp x)
    (if (peval (test x) a)
      (peval (tb x) a)
      (peval (fb x) a))
    (aeval x a)))

; Test peval
(let ((x 'c))
  (cdr (assoc x '((c . t) (b . nil)))))
(peval '(if (if t c b) c b) '((c . t) (b . nil)))

      
;;; Exercise 11.39

; [JM] Some test about aeval
(let ((x 'd))
  (aeval x '((c . t) (b . nil))))
; Return NIL

; [JM] assume x is normalized
;(defun tautp (x a)
;  (cond ((ifp x) (and (tautp (tb x) a)
;                      (tautp (fb x) a)))
;        (t (aeval x a))))
;
; [JM] This version tautp is too strong
;      An appropriate tautp needs and only needs care about (tb x) when (test x) is t
;      and cares about (fb x) when (test x) is nil

(defun assumep (x a)
  (or (booleanp x)
      (assoc x a)))
; Test assumep
(let ((x 'd))
  (assumep x '((d . t) (c . nil))))
(let ((x 'a))
  (assumep x '((d . t) (c . nil))))

(defun assume-t (x a)
  (cons (cons x t)
        a))

(defun assume-nil (x a)
  (cons (cons x nil)
        a))
    
(defun tautp (x a)
  (cond ((ifp x) (if (assumep (test x) a)
                   (if (aeval (test x) a)
                     (tautp (tb x) a)
                     (tautp (fb x) a))
                   ; (test x) is not boolean or assumed, assume both case
                   (and (tautp (tb x)
                               (assume-t (test x) a))
                        (tautp (fb x)
                               (assume-nil (test x) a)))))
        (t (aeval x a))))


(defun tautp-chk (x)
  (tautp (if-n x) nil))
; Test tautp-chk
(tautp-chk '(if nil t t))
(tautp-chk '(if nil nil t))
(tautp-chk '(if nil (if nil t t) t))
(tautp-chk '(if nil (if nil t nil) t))
(tautp-chk '(if (if nil t nil) nil t))
    
;;; Exercise 11.40
; Proof helper
;Subgoal *1/5.2
;(IMPLIES (AND (CONSP X)
;              (EQUAL (CAR X) 'IF)
;              (NOT (CONSP (CADR X)))
;              (NOT (TAUTP (IF-N (CADDR X)) NIL))
;              (PEVAL (CADDDR X) A)
;              (NOT (BOOLEANP (CADR X)))
;              (TAUTP (IF-N (CADDR X))
;                     (LIST (CONS (CADR X) T)))
;              (TAUTP (IF-N (CADDDR X))
;                     (LIST (LIST (CADR X))))
;              (CDR (ASSOC-EQUAL (CADR X) A)))
;         (PEVAL (CADDR X) A))
;
;Subgoal *1/5.1
;(IMPLIES (AND (CONSP X)
;              (EQUAL (CAR X) 'IF)
;              (NOT (EQUAL (CAR (CADR X)) 'IF))
;              (NOT (TAUTP (IF-N (CADDR X)) NIL))
;              (PEVAL (CADDDR X) A)
;              (NOT (BOOLEANP (CADR X)))
;              (TAUTP (IF-N (CADDR X))
;                     (LIST (CONS (CADR X) T)))
;              (TAUTP (IF-N (CADDDR X))
;                     (LIST (LIST (CADR X))))
;              (CDR (ASSOC-EQUAL (CADR X) A)))
;         (PEVAL (CADDR X) A))
;
;Subgoal *1/4.3
;(IMPLIES (AND (CONSP X)
;              (EQUAL (CAR X) 'IF)
;              (NOT (CONSP (CADR X)))
;              (PEVAL (CADDR X) A)
;              (NOT (TAUTP (IF-N (CADDDR X)) NIL))
;              (NOT (BOOLEANP (CADR X)))
;              (TAUTP (IF-N (CADDR X))
;                     (LIST (CONS (CADR X) T)))
;              (TAUTP (IF-N (CADDDR X))
;                     (LIST (LIST (CADR X))))
;              (NOT (CDR (ASSOC-EQUAL (CADR X) A))))
;         (PEVAL (CADDDR X) A))
;
; [JM] It seems these three subgoal can never be proofed directly,
;      since they are the same as the goal.
;      Check more subgoal
:set-checkpoint-summary-limit nil
; [JM] Almost the same subgoal, try to read more proof log
:set-gag-mode t
; [JM] No idea where goes wrong, try some helper from solution
; ==== From solution ====
; Here we determine if x is in if-normal form.

(defun normp (x)
  (if (ifp x)
      (and (not (ifp (test x)))
           (normp (tb x))
           (normp (fb x)))
    t))

; These lemmas were generated with The Method.  Append was introduced
; into the problem in tautp-implies-peval, below, because we must
; generalize from the empty initial assignment to an arbitrary one.

(defthm assoc-equal-append
  (implies (alistp a)
           (equal (assoc-equal v (append a b))
                  (if (assoc-equal v a)
                      (assoc-equal v a)
                    (assoc-equal v b)))))

; If a variable is already assigned value val, a new pair binding it to
; val can be ignored (in the sense that no peval is changed).

(defthm peval-ignores-redundant-assignments
  (implies (iff (cdr (assoc-equal var alist)) val)
           (iff (peval x (cons (cons var val) alist))
                (peval x alist))))

; So here is the main soundness result about tautp: if the expression is in
; if-normal form and is a tautology under some assignment, then its value is
; true under any extension of that assignment.  In our intended use, b will
; be nil, and so the (append b a) expression will just be a.  Thus, this
; lemma is not going to be used as a rewrite rule -- (append nil a) will not
; occur in the target.  Instead we will :use it explicitly.  So we make it of
; :rule-classes nil.

(defthm tautp-implies-peval
  (implies (and (alistp b)
                (normp x)
                (tautp x b))
           (peval x (append b a)))
  :rule-classes nil)

; Now we deal with the normalization phase.  We prove that if-n normalizes
; while preserving the value under all assignments.

(defthm normp-if-n
  (normp (if-n x)))

(defthm peval-if-n
  (equal (peval (if-n x) a)
         (peval x a)))

; We can now put these together.
; ==== End of solution ====

; Proof target
(defthm tautp-sound
  (implies (tautp-chk x)
           (peval x a))
  :hints (("Goal" :use (:instance tautp-implies-peval
                                  (x (if-n x))
                                  (b nil)))))#|ACL2s-ToDo-Line|#


;;; Exercise 11.41

; [JM] Too difficulty for me, come back later
; Proof target
(defthm tautp-complete
  (implies (not (tautp-chk x))
           (not (peval x a))))
 
