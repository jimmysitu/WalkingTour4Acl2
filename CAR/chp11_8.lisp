;;; Execrise 11.52
(defun nats (n)
  (if (zp n)
    nil
    (cons (- n 1) (nats (- n 1)))))

(defun xtr (map lst)
  (if (endp map)
    nil
    (cons (nth (car map) lst)
          (xtr (cdr map) lst))))

(defun app (x y)
  (if (endp x)
      y
    (cons (car x)
          (app (cdr x) y)))) 

(defun rev (x)
  (if (endp x)
    nil
    (app (rev (cdr x)) (list (car x)))))#|ACL2s-ToDo-Line|#


; Proof helpers
;Subgoal *1/2''
;(IMPLIES (AND (CONSP X)
;              (EQUAL (XTR (NATS (LEN (CDR X))) (CDR X))
;                     (REV (CDR X))))
;         (EQUAL (CONS (NTH (LEN (CDR X)) X)
;                      (XTR (NATS (LEN (CDR X))) X))
;                (APP (REV (CDR X)) (LIST (CAR X)))))

; [JM] come back later

; Proof target
(defthm xrt-equal-rev
  (equal (xtr (nats (len x)) x)
         (rev x)))


