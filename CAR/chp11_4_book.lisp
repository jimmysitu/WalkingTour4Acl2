; This time we start with a standard arithmetic book.
(include-book "arithmetic/top-with-meta" :dir :system)

;;; Exercise 11.26
(defun sum26 (n)
  (declare (xargs :guard (natp n)))
  (cond ((zp n) 0)
        (t (+ n (sum26 (- n 1))))))


;Proof target
(defthm sum26-thm
  (implies (natp n)
           (equal (sum26 n)
                  (/ (* n (+ n 1)) 2))))

;;; Exercise 11.27
(defun sum27 (n)
  (cond ((zp n) 0)
        (t (+ (* 3 n n)
              (- (* 3 n))
              1 
              (sum27 (- n 1))))))

(defthm sum27-thm
  (implies (natp n)
           (equal (sum27 n)
                  (* n n n))))

;;; Exercise 11.28
(defun sum28 (n)
  (cond ((zp n) 0)
        (t (+ (* n n)
              (sum28 (- n 1))))))

(defthm sum28-thm
  (implies (natp n)
           (equal (sum28 n)
                  (/ (* n (+ n 1) (+ (* 2 n) 1))
                     6))))#|ACL2s-ToDo-Line|#


;;; Exercise 11.29






