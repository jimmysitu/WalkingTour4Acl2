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
                     6))))

;;; Exercise 11.29
(defun sum29 (n)
  (cond ((zp n) 0)
        (t (+ (* (* 2 n) (* 2 n)) (sum29 (- n 1))))))

(defthm sum29-thm
  (implies (natp n)
           (equal (sum29 n)
                  (/ (* 2 n (+ n 1) (+ (* 2 n) 1))
                     3))))

;;; Exercise 11.30
(defun sum30 (n)
  (cond ((zp n) 0)
        (t (+ (* n n n) (sum30 (- n 1))))))

(defthm sum30-thm
  (implies (natp n)
           (equal (sum30 n)
                  (/ (* n n (+ n 1) (+ n 1))
                     4))))

;;; Exercise 11.31
(defun sum31 (n)
  (cond ((zp n) 0)
        (t (+ (/ 1
                 (* n (+ n 1)))
              (sum31 (- n 1))))))

; Test theorem
(let ((n 4))
  (equal (sum31 n)
         (/ n (+ n 1))))
(let ((n 100))
  (equal (sum31 n)
         (/ n (+ n 1))))

; Proof helper
;Subgoal *1/3'
;(IMPLIES (AND (NOT (ZP N))
;              (EQUAL (+ -1 N)
;                     (+ (SUM31 (+ -1 N))
;                        (* (+ -1 N) (SUM31 (+ -1 N))))))
;         (EQUAL N
;                (+ (SUM31 (+ -1 N))
;                   (* N (SUM31 (+ -1 N)))
;                   (/ (+ N (* N N)))
;                   (* N (/ (+ N (* N N)))))))
;
; [JM] Just try some simplify rewrite
(defthm common-denominator-thm
  (implies (not (zp y))
           (equal (+ (* x (/ y))
                     (* z (/ y)))
                  (* (+ x z) (/ y)))))

(defthm reduct-fraction-thm
  (implies (not (zp n))
           (equal (/ 1 n)
                  (* n (/ (* n n))))))

(defthm combine-fraction-thm
  (equal (+ n (* n n))
         (* n (+ n 1))))

; [JM] Try to add some hints
(defthm sum31-thm-helper0
  (implies (not (zp n))
           (equal (/ 1 n)
                  (+ (/ (+ n (* n n)))
                     (* n (/ (+ n (* n n)))))))
  :hints (("goal" :in-theory (disable distributivity)
                  :use ((:instance common-denominator-thm
                         (x 1)
                         (y (+ n (* n n)))
                         (z n)))
                  )))

; [JM] Try to rewrite hypothesis in subgoal *1/3', sum31-thm-helper1
(defthm simplify-add
  (equal (+ a (* (- n 1) a))
         (* n a)))
            
(defthm sum31-thm-helper1
  (implies (and (not (zp n))
                (equal (- n 1)
                       (+ (sum31 (- n 1))
                          (* (- n 1) (sum31 (- n 1))))))
           (equal (- n 1)
                  (* n (sum31 (- n 1))))))#|ACL2s-ToDo-Line|#


(cw-gstack :frames 30)
; [JM] Try to disable distributivity to break rewrite loop
; Proof target
(defthm sum31-thm
  (implies (natp n)
           (equal (sum31 n)
                  (/ n (+ n 1))))
  :hints (("goal" :in-theory (disable distributivity))
          ("subgoal *1/3''" :in-theory (enable distributivity))))




;;; Exercise 11.32


;;; Exercise 11.33


