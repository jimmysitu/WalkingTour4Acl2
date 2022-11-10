;;; Exercise 11.26
(defun sum26 (n)
  (declare (xargs :guard (natp n)))
  (cond ((zp n) 0)
        (t (+ n (sum26 (- n 1))))))

; test sum
(sum26 1)
(sum26 4)


; Proof helper
;Subgoal *1/2'
;(IMPLIES (AND (NOT (ZP N))
;              (EQUAL (SUM26 (+ -1 N))
;                     (+ (* 1/2 N)
;                        (* -1/2 N)
;                        (* (+ -1 N) 1/2 N))))
;         (EQUAL (+ N (SUM26 (+ -1 N)))
;                (+ (* 1/2 N) (* N 1/2 N))))
;
;Subgoal *1/1'
;(IMPLIES (ZP N)
;         (EQUAL 0 (+ (* 1/2 N) (* N 1/2 N))))
;
; [JM] From *1/2', need to proof,
;      sum26(n) = n + sum26(n-1)
;
; [JM] Form *1/1', need to proof,
;      if (zp n), (* n x) = 0
;      Doubld check definition of zp, it returns t if n is not a natural. 
;      It seem need to restrict n more
; 
; (drop)Proof target
;(defthm sum26-thm
;  (equal (sum26 n)
;         (/ (* n (+ n 1)) 2)))
; ============================================
; Try again
;Subgoal *1/4'
;(IMPLIES (AND (NOT (ZP N))
;              (EQUAL (SUM26 (+ -1 N))
;                     (+ (* 1/2 N)
;                        (* -1/2 N)
;                        (* (+ -1 N) 1/2 N)))
;              (<= 0 N))
;         (EQUAL (+ N (SUM26 (+ -1 N)))
;                (+ (* 1/2 N) (* N 1/2 N))))
; 
; [JM] From *1/4', need to proof,
;      sum26(n) = n + sum26(n-1)
(defthm sum26-n-1
  (implies (natp n)
           (equal (sum26 n)
                  (+ n (sum26 (- n 1))))))

; [JM] Move on a little
;Goal''
;(IMPLIES (AND (INTEGERP N) (<= 0 N))
;         (EQUAL (+ N (SUM26 (+ -1 N)))
;                (+ (* 1/2 N) (* N 1/2 N))))
;
;Proof target
(defthm sum26-thm
  (implies (natp n)
           (equal (sum26 n)
                  (/ (* n (+ n 1)) 2))))

