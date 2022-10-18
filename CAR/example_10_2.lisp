; ACL2 cannot prove it directly
;(defthm commutativity-of-*-2
;  (equal (* y (* x z))
;         (* x (* y z))))

; Using hints
(defthm commutativity-of-*-2
  (equal (* y (* x z))
         (* x (* y z)))
  :hints (("Goal"
           :use ((:instance associativity-of-* (y x) (x y))
                 (:instance associativity-of-*))
           :in-theory (disable associativity-of-*))))

; Using encapsulate to define ac-fun,
; a constrained function about which we know only that it is associative and commutative.
(encapsulate
  ((ac-fun (x y) t))
  (local (defun ac-fun (x y) (declare (ignore x y))
           nil))
  (defthm associativity-of-ac-fun
    (equal (ac-fun (ac-fun x y) z)
           (ac-fun x (ac-fun y z))))
  (defthm commutativity-of-ac-fun
    (equal (ac-fun x y)
           (ac-fun y x))))
 
; This should have the same problem
;(thm
; (equal
;  (ac-fun (ac-fun f (ac-fun c d)) (ac-fun (ac-fun c b) a))
;  (ac-fun (ac-fun (ac-fun a c) b) (ac-fun c (ac-fun d f)))))

; Using hints, it should work
(defthm commutativity-2-of-ac-fun
  (equal (ac-fun y (ac-fun x z))
         (ac-fun x (ac-fun y z)))
  :hints (("Goal"
           :in-theory (disable associativity-of-ac-fun)
           :use ((:instance associativity-of-ac-fun)
                 (:instance associativity-of-ac-fun (x y) (y x))))))

(defthm commutativity-2-of-* 
  (equal (* y (* x z))
         (* x (* y z)))
  :hints (("Goal" 
           :by (:functional-instance
                commutativity-2-of-ac-fun 
                (ac-fun (lambda (x y) (* x y)))))))

; Define a function to make it conveniet to create symbols
(defun make-name (prefix name)
  (intern-in-package-of-symbol
   (concatenate 'string
                (symbol-name prefix)
                "-"
                (symbol-name name))
   prefix))

; Define macro
(defmacro commutativity-2 (op)
  `(defthm ,(make-name 'commutativity-2-of op)
     (equal (,op y (,op x z))
            (,op x (,op y z)))
     :hints (("Goal"
              :by (:functional-instance
                   commutativity-2-of-ac-fun
                   (ac-fun (lambda (x y) (,op x y))))))))

; Define theorm of commutativity of multiplier
(commutativity-2 *)#|ACL2s-ToDo-Line|#


                            
                            
                            
                            

         