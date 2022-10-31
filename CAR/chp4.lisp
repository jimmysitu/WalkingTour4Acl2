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
(cast-out-nines 9999)
                       
                       
;;; Exercise 4.11
(defun fact (n)
  (declare (xargs :mode :program))
  (if (zp n)
    1
    (* n (fact (- n 1)))))
; Test fact
(fact 1)
(fact 2)
(fact 3)

(defun fact-tailrec (n acc)
  (declare (xargs :mode :program))
  (if (zp n)
    acc
    (fact-tailrec (- n 1) (* n acc))))
(defun fact1 (n)
  (declare (xargs :mode :program))
  (fact-tailrec n 1))
; Test fact1
(fact1 1)
(fact1 2)
(fact1 3)

;;; Exercise 4.12
(defun get-keys-tailrec (alist acc)
  (declare (xargs :mode :program))
  (if (endp alist)
    acc
    (get-keys-tailrec (cdr alist) (append acc (list (caar alist))))))

(defun get-keys1 (alist)
  (declare (xargs :mode :program))
  (get-keys-tailrec alist nil))
; Test get-keys1
(get-keys1 '((c. 5) (b . 4) (a . 3) (c . 2)))

(defun update-alist-rec-tailrec (key val alist acc)
  (cond ((endp alist) (append acc (list (cons key val))))
        ((equal key (caar alist))
         (append acc (cons (cons key val) (cdr alist))))
        (t (update-alist-rec-tailrec key val (cdr alist) (append acc (list (car alist)))))))

(defun update-alist-rec1 (key val alist)
  (update-alist-rec-tailrec key val alist nil))
; Test
(update-alist-rec1 'b 17 '((c . 5) (b . 4) (a . 3)))
(update-alist-rec1 'c 17 '((c . 5) (b . 4) (a . 3)))
(update-alist-rec1 'd 17 '((c . 5) (b . 4) (a . 3)))

(defun next-k-iter-tailrec (k acc)
  (declare (xargs :mode :program))
  (cond ((equal 1 k) acc)
        (t (next-k-iter-tailrec (next-k k) (+ 1 acc)))))
(defun next-k-iter1 (k)
  (declare (xargs :mode :program))
  (next-k-iter-tailrec k 0))
; Test
(next-k-iter1 11)
         
(defun next-k-max-iterations-tailrec (n acc)
  (declare (xargs :mode :program))
  (cond ((equal 1 n) acc)
        (t (next-k-max-iterations-tailrec (- n 1) (max (next-k-iter n) acc)))))
(defun next-k-max-iterations1 (n)
  (declare (xargs :mode :program))
  (next-k-max-iterations-tailrec n 0))
; Test
(next-k-max-iterations1 4)
(next-k-max-iterations1 10000)

;;; Exercise 4.13
(defun split-list (x)
  (cond ((endp x) (mv nil nil))
        (t (mv-let (evens odds)
                   (split-list (cdr x))
                   (mv (cons (car x) odds) evens)))))
; Test splist-list
(split-list '(3 6 2 9 2 8 3/2))
(split-list '(3 6 2 9 2 8 7 3/2))
(split-list '(1))
(split-list '(1 2))

(mv-let (odds events)
        (split-list '(3 6 2 9 2 8 7 3/2))
        (append odds events))

;;; Exercise 4.14
(defun merge2 (x y)
  (declare (xargs :mode :program))
  (cond ((endp x) y)
        ((endp y) x)
        ((< (car x) (car y))
         (cons (car x) (merge2 (cdr x) y)))
        (t (cons (car y) (merge2 x (cdr y))))))
; Test merge2
(merge2 '(2 2 3 7) '(3/2 6 8 9))
(merge2 '(2 2 3 7) '())
(merge2 '() '(3/2 6 8 9))

;;; Exercise 4.15
(defun mergesort (x)
  (declare (xargs :mode :program))
  (cond ((endp x) nil)
        ((equal 1 (len x)) x)
        (t (mv-let (odds evens)
                   (split-list x)
                   (merge2 (mergesort odds) (mergesort evens))))))
; Test mergesort
(mergesort '(3 6 2 9 2 8 7 3/2))
(mergesort '(3))
(mergesort '(3 2))#|ACL2s-ToDo-Line|#

(mergesort '())


;;; Exercise 4.16
; Some test
(symbolp '(a b c))

(mutual-recursion
 (defun acl2-basic-termp (x)
   (declare (xargs :mode :program))
   (cond ((symbolp x) t)
         ((acl2-numberp x) t)
         ((characterp x) t)
         ((stringp x) t)
         ((consp x) (acl2-basic-term-listp x))
         (t nil)))
 
 (defun acl2-basic-term-listp (x)
   (declare (xargs :mode :program))
   (cond ((endp x) t)
         ((acl2-basic-termp (car x)) (acl2-basic-term-listp (cdr x)))
         (t nil)))
)
(acl2-basic-termp 'a)
(acl2-basic-term-listp '(a c))
(acl2-basic-termp '(a 3 c))
         
;;; Exercise 4.17
(defun acl2-sub (new old x)
  (declare (xargs :mode :program))
  (cond ((endp x) nil)
        ((equal old (car x)) (cons new (cdr x)))
        (t (cons (car x) (acl2-sub new old (cdr x))))))
; Test acl2-sub
(acl2-sub '(f x) '(g y) '(h (g x) (g y) 17))

;;; Exercise 4.18
; Some test
(car '(= 22 (+ x (* y 3))))
(cadr '(= 22 (+ x (* y 3))))
(caddr '(= 22 (+ x (* y 3))))
(assoc-eq 'x '((x . 1) (y . 7)))
(defun acl2-value (x a)
  (cond ((eq x nil) nil)
        ((eq x t) t)
        ((acl2-numberp x) x)
        ((characterp x) x)
        ((stringp x) x)
        ((symbolp x) (if (assoc-eq x a)
                         (cdr (assoc-eq x a))
                         0))
        (t (cond ((eq (car x) '=)
                  (equal (acl2-value (cadr x) a)
                         (acl2-value (caddr x) a)))
                 ((eq (car x) '+)
                  (+ (acl2-value (cadr x) a)
                     (acl2-value (caddr x) a)))
                 ((eq (car x) '*)
                  (* (acl2-value (cadr x) a)
                     (acl2-value (caddr x) a)))
                 (t nil)))))
; Test acl2-value
(acl2-value 22 nil)
(acl2-value '(= 22 (+ x (* y 3))) '((x . 1) (y . 7)))
(acl2-value '(= 22 (+ x (* y 3))) '((x . 3) (y . 7)))

(program)
;;; Exercise 4.19
; Solution from github
(defun next-k-ar (k ar bound)
  (let ((next-k-try (and (< k bound)
                         (aref1 'next-k-array ar k))))
    (if next-k-try
        (mv next-k-try ar)
      (let ((next-k (next-k k)))
        (mv next-k
            (if (< k bound)
                (aset1 'next-k-array ar k next-k)
              ar))))))

(defun next-k-iterations-ar-rec (k ar bound acc)
  (if (int= k 1)
      (mv acc ar)
    (mv-let (next-k ar)
            (next-k-ar k ar bound)
            (next-k-iterations-ar-rec next-k ar bound (1+ acc)))))

(defun next-k-array (size)
  (compress1 'next-k-array
             `((:header :dimensions (,size)
                        :maximum-length ,(* size 2)
                        :default nil
                        :name next-k-array))))

(defun next-k-iterations-ar (k)
  (next-k-iterations-ar-rec k (next-k-array k) k 0))

(defun next-k-max-iterations-ar-rec (n ar bound max)
  (if (int= n 1)
      max
    (mv-let (iterations ar)
            (next-k-iterations-ar-rec n ar bound 0)
            (next-k-max-iterations-ar-rec
             (1- n)
             ar
             bound
             (max max iterations)))))

(defun next-k-max-iterations-ar (n)
  (next-k-max-iterations-ar-rec n (next-k-array n) n 0))
                         
                                 
;;; Exercise 4.20
; Solution from github
(defstobj st
  ;; The prev field stores scratchwork.  The ans field is an array associating
  ;; with each i the number of iterations of next-k required to reach 1,
  (prev :type integer :initially 0)
  (ans :type (array integer (100001)) :initially -1))

(defconst *len* 100001)

; The following macro increases readability:
; (seq x form1 form2 ... formk)
; binds x to successive values of formi.
(defmacro seq (stobj &rest rst)
  (cond ((endp rst) stobj)
        ((endp (cdr rst)) (car rst))
        (t `(let ((,stobj ,(car rst)))
             (seq ,stobj ,@(cdr rst))))))

; The following function updates st with all values computed along the way to
; computing the number of iterations of next-i required to reach 1 from i.
; That number, for i, is stored in the prev field of the stobj st.
(defun fill-in (i st)
  (declare (xargs :stobjs (st)))
  (cond ((< i *len*)
     (if (= (ansi i st) -1)
         (seq st
          (fill-in (next-k i) st)
          (update-ansi i (1+ (prev st)) st)
          (update-prev (1+ (prev st)) st))
       (update-prev (ansi i st) st)))
    (t (seq st
        (fill-in (next-k i) st)
        (update-prev (1+ (prev st)) st)))))

; Call fill-in on all values from 1 to len, inclusive:
(defun fill-all-in (cnt len st)
  (declare (xargs :stobjs (st)))
  (cond ((> cnt len)
     st)
    (t (seq st
        (fill-in cnt st)
        (fill-all-in (1+ cnt) len st)))))

; Find the maximum number of iterations for all integers from i to len,
; inclusive:
(defun max-st (cnt m len st)
  (declare (xargs :stobjs (st)))
  (cond ((> cnt len) m)
    (t (if (> (ansi cnt st) m)
           (max-st (1+ cnt) (ansi cnt st) len st)
         (max-st (1+ cnt) m len st)))))

; This function fills in st (as described for fill-in above) and then stores
; the maximum number of iterations in the prev field of st.
(defun next-k-max-iterations-stobj-aux (len st)
  (declare (xargs :stobjs (st)))
  (seq st
       (update-ansi 0 0 st)
       (update-ansi 1 0 st)
       (fill-all-in 2 len st)
       (update-prev (max-st 2 0 len st) st)))

(defun next-k-max-iterations-stobj (len st)
  (declare (xargs :stobjs (st)))
  (let ((st (next-k-max-iterations-stobj-aux len st)))
    (mv (prev st) st)))

;;; Exercise 4.21
(time$ (next-k-max-iterations 50000)) ; basic
(time$ (next-k-max-iterations1 50000)) ; tail recursive
(time$ (next-k-max-iterations-ar 50000)) ; arrays
(time$ (next-k-max-iterations-stobj 50000 st)) ; stobj

         
         
         
         
         
         
         
         
         