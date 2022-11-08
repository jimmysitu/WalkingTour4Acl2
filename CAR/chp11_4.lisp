;;; Exercise 11.26
(defun sum (n)
  (declare (xargs :measure (acl2-count n)))
  (cond (0 0)
        (t (+ n (sum (- n 1))))))#|ACL2s-ToDo-Line|#



