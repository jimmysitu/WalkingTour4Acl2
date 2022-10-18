;;; Example in 10.1
(defun fact (x)
  (if (zp x)
    1
    (* x (fact (- x 1)))))

(defun tfact (x p)
  (if (zp x)
    p
    (tfact (- x 1) (* x p))))

:comp (fact tfact)

(verify
  (equal (tfact x 1) (fact x)))

(include-book "arithmetic/top-with-meta" :dir :system)

; This is not theorem when p is not a number
;(defthm fact=tfact-lemma
;  (equal (tfact x p)
;         (* p (fact x))))
(defthm fact=tfact-lemma-for-acl2-memberp
  (implies (acl2-numberp p)
           (equal (tfact x p)
                  (* p (fact x)))))

(defthm fact=tfact
  (equal (tfact x 1) (fact x)))

(defun tfact2 (x p)
  (if (zp x)
    (fix p)
    (tfact2 (- x 1) (* x p))))

(thm (equal (tfact2 x p)
            (* p (fact x))))#|ACL2s-ToDo-Line|#

