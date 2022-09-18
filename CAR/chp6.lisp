;;; Exercise 6.3
; Solution from github
(include-book "ordinals/e0-ordinal" :dir :system)
(set-well-founded-relation e0-ord-<)

(defthm w-larger-than-nats
  (implies (natp x)
       (e0-ord-< x '(1 . 0))))

(defthm w-smaller-than-non-nats
  (implies (and (e0-ordinalp x)
        (not (natp x))
        (not (equal x '(1 . 0))))
       (e0-ord-< '(1 . 0) x)))



;;; Exercise 6.4
(e0-ordinalp '(2 1 . 27))
; T, w^2+w+27

(e0-ordinalp '(2 1 1 . 27))
; T, w^2+(w*2)+27

(e0-ordinalp '(2 1 0 . 27))
; NIL

(e0-ordinalp '(1 2 2 . 27))
; NIL


;;; Exercise 6.6
; Soluction from github
(defthm e0-cons-pos
  (implies (and (natp i1)
                (natp i2))
           (iff (e0-ordinalp (cons i1 i2))
                (< 0 i1))))
; (natp i1) & (natp i2) -> (e0-ordinalp (i1.i2)) <-> (0 < i1)
; JM: (natp i1) includes 0

(defthm e0-cons
  (implies (and (natp i1)
        (natp i2))
       (e0-ordinalp (cons (1+ i1) i2))))

(defthm e0-<-nats
  (implies (and (natp i1)
        (natp i2)
        (natp j1)
        (natp j2))
       (iff (e0-ord-< (cons (1+ i1) i2)
              (cons (1+ j1) j2))
        (or (< i1 j1)
            (and (equal i1 j1)
             (< i2 j2))))))

;;; Exercise 6.8
; Solution from github
; Pending

;;; Exercise 6.11
; Solution from github
(defun upto (i max)
  (declare (xargs :measure (nfix (- (1+ max) i))))
  (if (and (integerp i)
           (integerp max)
           (<= i max))
      (+ 1 (upto (+ 1 i) max))
    0))

(upto 7 12)


;;; Exercise 6.12
(defun g (i j)
  (declare (xargs :measure (nfix (+ i j))))
  (if (zp i)
      j
    (if (zp j)
        i
      (if (< i j)
          (g i (- j i))
        (g (- i j) j)))))

(g 18 45) 
(g 7 9)

;;; Exercise 6.13
(defun mlen (x y)
  (declare (xargs :measure (+ (acl2-count x) (acl2-count y))))
  (if (or (consp x) (consp y))
      (+ 1 (mlen (cdr x) (cdr y)))
    0))

(mlen '(a b c ) '(a b c d e))

;;; Exercise 6.14
; Soluction from github
(defun flen (x)
  (declare (xargs :measure (if (null x) 0 (1+ (acl2-count x)))))
  (if (equal x nil)
      0
    (+ 1 (flen (cdr x)))))

(flen '(a b c))
(flen '(a b c 7))
; JM: Error in (flen '(a b c . 7))

;;; Exercise 6.15
; Solution from github
(defun ack (x y)
   (declare (xargs :measure (cons (1+ (nfix y)) (nfix x))))
   (if (zp x)
       1
     (if (zp y)
         (if (equal x 1) 2 (+ x 2))
       (ack (ack (1- x) y) (1- y)))))#|ACL2s-ToDo-Line|#


