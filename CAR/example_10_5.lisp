; Define boolean valued functions
(defun band (p q) (if P (if q t nil) nil))

(defun bor (p q) (if P t (if q t nil)))

(defun bxor (p q) (if P (if q nil t) (if q t nil)))

(defun bmaj (p q c)
  (bor (band p q) 
       (bor (band p c)
            (band q c))))

; 1 bit full adder
(defun full-adder (p q c)
  (mv (bxor p (bxor q c)) ;sum
      (bmaj p q c)))      ;carry

; Serial bit adder
(defun serial-adder (x y c)
  (declare (xargs :measure (+ (len x) (len y))))
  (if (and (endp x) (endp y))
    (list c)
    (mv-let (sum cout)
            (full-adder (car x) (car y) c)
            (cons sum (serial-adder (cdr x) (cdr y) cout)))))

; Binary to nature number
(defun n (v)
  (cond ((endp v) 0)
        ((car v) (+ 1 (* 2 (n (cdr v)))))
        (t (* 2 (n (cdr v))))))

; Some test for n(v), t = 1, nil = 0, LSB first
(n '(nil nil));0
(n '(nil t));2
(n '(t t));3
(n '(nil t t));6

; Proof helper
(defthm serial-adder-coorect-nil-nil
  (equal (n (serial-adder x nil nil))
         (n x)))

(defthm serial-adder-correct-nil-t
  (equal (n (serial-adder x nil t))
         (+ 1 (n x))))

; Proof serial adder is correct
(defthm serial-adder-correct
  (equal (n (serial-adder x y c))
         (+ (n x) (n y) (if c 1 0))))

; Binary multiplier
(defun multiplier (x y p)
  (if (endp x)
    p
    (multiplier (cdr x)
                (cons nil y); * 2, shift left
                (if (car x)
                  (serial-adder y p nil)
                  p))))

; Proof helper
; From 10.2, using hints
(defthm commutativity-of-*-2
  (equal (* y (* x z))
         (* x (* y z)))
  :hints (("Goal"
           :use ((:instance associativity-of-* (y x) (x y))
                 (:instance associativity-of-*))
           :in-theory (disable associativity-of-*))))
  
; Proof multiplier correct
(defthm multiplier-correct
  (equal (n (multiplier x y p))
            (+ (* (n x) (n y)) (n p))))#|ACL2s-ToDo-Line|#


