;;; Example in 9.2
(defun app (x y)
  (if (endp x)
    y
    (cons (car x)
          (app (cdr x) y))))



; Unmask this comment to get fail attempt
;:set-gag-mode nil
;(defthm main
;  (equal (app (app a a) a)
;         (app a (app a a)))
;  :rule-classes nil)
;
; [JM] the problem is destructor elimination try to replace
; (CAR A) by A1 and (CDR A) by A2
; this elimination add extra hypothesis, A1 A2 end with NIL
; which not always the true, see counterexample below
;(app '(1 2 3) 
;     '(4 5 6))
;
;(app '((1 . 2) . 3) 
;     '(4 5 6))
; The second example is not work by the guard of app

; Unmask this comment to get successfull proof
:set-gag-mode nil
(defthm associativity-of-app
  (equal (app (app a b) c)
         (app a (app b c))))

(defthm main-9-2
  (equal (app (app a a) a)
         (app a (app a a)))
  :rule-classes nil)

;;; Example in 9.3
(defun rev (x)
  (if (endp x)
    nil
    (app (rev (cdr x)) (list (car x)))))

:set-gag-mode t
(defthm rev-rev
  (implies (true-listp a)
           (equal (rev (rev a)) a)))

; [JM] proof attempt fail
; Add rewrite rule
(defthm consp-rev
  (equal (consp (rev x))
         (consp x)))

(defthm true-listp-rev
  (true-listp (rev x)))

(defthm true-listp-cdr
  (implies (true-listp x)
           (true-listp (cdr x))))

(defthm main-9-3
  (equal (rev x)
         (if (endp x)
           nil
           (if (endp (cdr x))
             (list (car x))
             (cons (car (rev (cdr x)))
                   (rev (cons (car x)
                              (rev (cdr (rev (cdr x))))))))))
  :rule-classes nil)#|ACL2s-ToDo-Line|#


