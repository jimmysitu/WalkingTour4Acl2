; Chp3
;;; Exercise 3.6
:trans (cond ((equal op 'incrmt) (+ x 1))
            ((equal op 'double) (* x 2))
            (t 0))

:trans (let ((x 1)
             (y x))
         (+ x y))

;;; Exercise 3.7
:trans (case op
      (incrmt (+ x 1))
      (double (* x 2))
      (otherwise 0))

;;; Exercise 3.8
(let ((x 3))
  (let ((x 1)
        (y x))
    (+ x y)))
;[JM] From exe 3.6, the lambda is actully doing 1+X. For 3.8, X=3, so the return should be 4

; Replace let with let*, check the expansion
:trans1 (let* ((x 1)
              (y x))
         (+ x y))

:trans (let* ((x 1)
             (y x))
        (+ x y))
;[JM] It is actually doing X+X
(let* ((x 1)
       (y x))
  (+ x y))
;[JM] With X=1, which should return 2

(let ((x 3))
  (declare (ignore x))
  (let* ((x 1)  ; x is 1
         (y x)) ; y is 1
    (+ x y)))

;;; Execrise 3.9
;1. twice the sum of x and y
(let ((x 3)
      (y 4))
  (* 2 (+ x y)))
; test one more
(let ((x 6)
      (y 4))
  (* 2 (+ x y)))

;2. the car of the cdr of x
(let ((x '(1 2 3)))
  (car (cdr x)))
; test another one list
(let ((x '(1 '(2 3))))
  (car (cdr x)))
; try to understand what happen here
(let ((x '(1 '(2 3))))
  (cdr x))
; try others
(let ((x '(1 2 (3 4))))
  (car (cdr x)))

;3. x is y
(let ((x 1) (y 1))
  (equal x y))

(let ((x 1) (y 2))
  (equal x y))

;4. x is a non-integer rational number
(let ((x 1))
  (and (not (integerp x)) (rationalp x)))

(let ((x 1/2))
  (and (not (integerp x)) (rationalp x)))#|ACL2s-ToDo-Line|#


;5. x is a symbol in the package SMITH
(let ((x 1))
  (and (symbolp x) (equal (symbol-package-name x) "SMITH")))

;6. 0, if x is a string; 1, otherwise
(let ((x "I am a string"))
  (if (stringp x) 0 1))
  
(let ((x 1))
  (if (stringp x) 0 1))

;;; Execrise 3.10
(defun fib (n)
  (if (or (zp n) (equal n 1))
    1 
    (+ (fib (- n 2)) 
       (fib (- n 1)))))
  
; Test fib
(fib 0)
(fib 1)
(fib 2)
(fib 3)
(fib 4)
(fib 5)
;(fib '(1 2 3))


;;; Execrise 3.11
(defun pascal (i j)
  (if (or (zp i) (zp j) (equal i j))
    1
    (+ (pascal (- i 1) (- j 1))
       (pascal (- i 1) j))))

; Test pascal
(pascal 0 0)
(pascal 1 0)
(pascal 2 0)
(pascal 8 0)
(pascal 2 1)
(pascal 3 1)
(pascal 3 2)
(pascal 5 3)
(pascal 5 4)
(pascal 6 2)


;;; Exercise 3.12
; helper
(defun mem (e x)
  (if (endp x)
    nil
    (if (equal e (car x))
      t
      (mem e (cdr x)))))

(defun subset (x y)
  (if (endp x)
    t
    (if (mem (car x) y)
      (subset (cdr x) y)
      nil)))
; Test subset
(subset '(1 2 3) '(3 4 2 9 7 1))
(subset '(1 2 0) '(3 4 2 9 7 1))

;;; Exercise 3.13
(defun un (x y)
  (cond ((endp x) y) 
        ((mem (car x) y)  (un (cdr x) y))
        (t (cons (car x) (un (cdr x) y)))))
; Test un
(un '(1 2 3) '(4 5 6))
(un '(1 2 3) '(1 2 3))
(un '(1 2 0) '(1 2 3))
(un '(1 2 0) '(1 2 2 3 4))
(un '(1 2 0 0 0 6 3) '(1 2 2 3 4))

;;; Exercise 3.14
(defun int (x y)
  (cond ((endp x) nil)
        ((mem (car x) y) (cons (car x) (int (cdr x) y)))
        (t (int (cdr x) y))))
; Test int
(int '(1 2 3) '(4 5 6))
(int '(1 2 3) '(1 5 6))
(int '(1 2 3) '(2 5 6 1 3))
(int '(1 2 3 6 7) '(1 3))

;;; Exercise 3.15
(defun diff (x y)
  (cond ((endp x) nil)
        ((mem (car x) y) (diff (cdr x) y))
        (t (cons (car x) (diff (cdr x) y)))))
; Test diff
(diff '(1 2 3) '(4 5 6))
(diff '(1 2 3) '(2 1 6))

;;; Exercise 3.16
(defun rev__ (x)
  (if (endp x)
    nil
    (append (rev__ (cdr x)) (list (car x)))))
; Test rev
(rev__ '(a b c d))
(rev__ '(a b c d e f g))

;;; Exercise 3.17
; helper
(defun insert (n x)
  (cond ((endp x) (list n))
        ((< n (car x)) (cons n x))
        (t (cons (car x) (insert n (cdr x))))))

(defun isort (x)
  (if (endp x)
    nil
    (insert (car x) (isort (cdr x)))))
; Test isort
(isort '(3 2 0 1 4))
(isort '(3 2 0 1 8 9 11 4))#|ACL2s-ToDo-Line|#

