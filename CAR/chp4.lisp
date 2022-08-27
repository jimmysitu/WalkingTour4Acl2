;;; Exercise 4.1
(defun from-end (n lst)
  (nth n (reverse lst)))
; Test from-end
(from-end 4 '(a b c d e f))

;;; Exercise 4.2
(defun update-alist (key val a)
  (cons (cons key val) a))
; Test update-alist
(assoc-equal 'b '((c . 5) (b . 4) (a . 3)))
(assoc-equal 'c '((c . 5) (b . 4) (a . 3)))
(assoc-equal 'b 
             (update-alist 'b 17 '((c . 5) (b . 4) (a . 3))))
(assoc-equal 'c 
             (update-alist 'b 17 '((c . 5) (b . 4) (a . 3))))
(assoc-equal 'd '((c . 5) (b . 4) (a . 3)))
(assoc-equal 'd 
             (update-alist 'b 17 '((c . 5) (b . 4) (a . 3))))

;;; Exercise 4.3
(defun next-k (k)
  (cond ((evenp k) (/ k 2))
        (t (+ 1 (* 3 k)))))
; Test next-k
(next-k 10)
(next-k 1)#|ACL2s-ToDo-Line|#


;;; Exercise 4.4
