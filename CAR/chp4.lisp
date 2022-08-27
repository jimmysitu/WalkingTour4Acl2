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
(next-k 1)

;;; Exercise 4.4
(defun mem (e x)
  (if (endp x)
    nil
    (if (equal e (car x))
      t
      (mem e (cdr x)))))

(defun no-dupls-p (lst)
  (cond ((atom lst) t)
        ((mem (car lst) (cdr lst)) nil)
        (t (no-dupls-p (cdr lst)))))
; Test no-dupls-p
(no-dupls-p '(a b c a d))
(no-dupls-p '(a b c d))

;;; Exercise 4.5
(defun get-keys (alist)
  (if (endp alist)
    nil
    (cons (caar alist)
          (get-keys (cdr alist)))))
; Test get-keys
(get-keys '((c. 5) (b . 4) (a . 3) (c . 2)))


;;; Exercise 4.6
(defun del (e lst)
  (cond ((endp lst) nil)
        ((equal e (car lst)) (cdr lst))
        (t (cons (car lst) (del e (cdr lst))))))

(defun perm (x y)
  (cond ((endp x) (endp y))
        ((mem (car x) y)
         (perm (cdr x) (del (car x) y)))
        (t nil)))
; Test perm
(perm '(a b c a) '(b a a c))
(perm '(a b c a) '(b a a c b))
(perm '(a b c a) '(a b c))

 ;;; Exercise 4.7
(defun update-alist-rec (key val alist)
  (cond ((endp alist) (list (cons key val)))
        ((equal key (caar alist))
         (cons (cons key val) (cdr alist)))
         (t (cons (car alist)
                  (update-alist-rec key val (cdr alist))))))

; Test update-alist-rec
(update-alist-rec 'b 17 '((c . 5) (b . 4) (a . 3)))
(update-alist-rec 'c 17 '((c . 5) (b . 4) (a . 3)))
(update-alist-rec 'd 17 '((c . 5) (b . 4) (a . 3)))
(equal
  (get-keys '((b . 4) (a . 3)))
  (get-keys (update-alist-rec 'a 17
                              '((b . 4) (a . 3)))))
                       

;;; Exercise 4.8
(defun next-k-iter-list (k)
  (declare (xargs :mode :program))
  (cond ((equal 1 k) k)
        (t (cons k (next-k-iter-list (next-k k))))))

(defun next-k-iter (k)
  (declare (xargs :mode :program))
  (cond ((equal 1 k) 0)
        (t (+ 1 (next-k-iter (next-k k))))))
; Test both
(next-k-iter-list 11)
(next-k-iter 11)

;;; Exercise 4.9
(defun next-k-max-iterations (n)
  (declare (xargs :mode :program))
  (cond ((equal 1 n) 0)
        (t (max (next-k-iter n)
                (next-k-max-iterations (- n 1))))))
; Test next-k-max-interations
(next-k-max-iterations 4)
(next-k-max-iterations 10000)

;;; Exercise 4.10
(defun sum-base-10 (n)
  (declare (xargs :mode :program))
  (cond ((zp n) 0)
        ((< n 10) n)
        (t (+ (mod n 10)
              (sum-base-10 (floor n 10))))))
  
(defun cast-out-nines (n)
  (declare (xargs :mode :program))
  (cond ((equal n 9) t)
        ((< n 9) nil)
        (t (cast-out-nines (sum-base-10 n)))))
; Test cast-out-nines
(cast-out-nines 9998)
(cast-out-nines 9999)#|ACL2s-ToDo-Line|#

                       
                       
