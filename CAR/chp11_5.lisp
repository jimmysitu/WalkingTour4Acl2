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
