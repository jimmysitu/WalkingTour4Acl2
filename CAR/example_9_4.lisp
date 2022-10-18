;;; Example in 9.4
(defun app (x y)
  (if (endp x)
    y
    (cons (car x)
          (app (cdr x) y))))

(defun rev (x)
  (if (endp x)
    nil
    (app (rev (cdr x)) (list (car x)))))

(defthm rev-rev
  (implies (true-listp a)
           (equal (rev (rev a)) a)))
  
(verify (equal (rev x)
               (if (endp x) nil
                 (if (endp (cdr x)) (list (car x))
                   (cons (car (rev (cdr x))) (rev
                                              (cons (car x) (rev (cdr (rev (cdr x)))))))))))

:set-gag-mode t
(defthm true-listp-rev
  (true-listp (rev x)))

(defthm true-listp-cdr
  (implies (true-listp x)
           (true-listp (cdr x))))

(verify)

(defthm consp-rev
  (equal (consp (rev x))
         (consp x)))

(verify)

(defthm main-9-4
  (equal (rev x)
         (if (endp x)
           nil
           (if (endp (cdr x))
             (list (car x))
             (cons (car (rev (cdr x)))
                   (rev (cons (car x)
                              (rev (cdr (rev (cdr x))))))))))
  :rule-classes nil)#|ACL2s-ToDo-Line|#


