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
(peval '(if (if t c b) c b) '((c . t) (b . nil)))#|ACL2s-ToDo-Line|#


      
      
      
    
  