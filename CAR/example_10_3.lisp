(defun insert (a x)
  (cond ((atom x) (list a))
        ((<= a (car x)) (cons a x))
        (t (cons (car x) (insert a (cdr x))))))

(defun insertion-sort (x)
  (cond ((atom x) nil)
        (t (insert (car x) (insertion-sort (cdr x))))))

(defun orderedp (x)
  (cond ((atom (cdr x)) t)
        (t (and (<= (car x) (cadr x))
                (orderedp (cdr x))))))

; Check insertion-sort is ordered
(defthm insertion-sort-is-ordered
  (orderedp (insertion-sort x)))

(defthm insert-ordered
  (implies (orderedp x)
           (orderedp (insert a x))))

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

; Check insertion-sort is a permutation of its input
(defthm insertion-sort-is-perm
  (perm (insertion-sort x) x))


(defthm insert-perm-cons
  (implies (perm x y)
           (perm (insert a x) (cons a y))))#|ACL2s-ToDo-Line|#






