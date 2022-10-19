(defpkg "COMPILE"
  (set-difference-eq
   (union-eq *acl2-exports*
             (union-eq '(acl2-numberp len)
                       *common-lisp-symbols-from-main-lisp-package*))
   '(pop push top compile step eval)))

(in-package "COMPILE")

; Define expression here
(defun exprp (exp)
  (cond
   ((atom exp)
    (or (symbolp exp) (acl2-numberp exp)))
   ((equal (len exp) 2)
    (and (or (equal (car exp) 'inc)
             (equal (car exp) 'sq))
         (exprp (cadr exp))))
  (t
   (and (equal (len exp) 3)
        (or (equal (cadr exp) '+)
            (equal (cadr exp) '*))
        (exprp (car exp))
        (exprp (caddr exp))))))


; Look up the value of a symbol in an environment
(defun lookup (var alist)
  (cond ((endp alist)
         0) ; default
        ((equal var (car (car alist)))
         (cdr (car alist)))
        (t (lookup var (cdr alist)))))

; Evaluate an expression in an environment
(defun eval (exp alist)
  (cond
   ((atom exp) (cond ((symbolp exp) (lookup exp alist))
                     (t exp)))
   ((equal (len exp) 2)
    (cond ((equal (car exp) 'inc)
           (+ 1 (eval (cadr exp) alist)))
          (t ; 'sq
           (* (eval (cadr exp) alist)
              (eval (cadr exp) alist)))))
   (t ; (equal (len exp) 3)
    (cond ((equal (cadr exp) '+)
           (+ (eval (car exp) alist)
              (eval (caddr exp) alist)))
          (t ; *
           (* (eval (car exp) alist)
              (eval (caddr exp) alist)))))))#|ACL2s-ToDo-Line|#


; Stack machine
; Basic operation
(defun pop (stk) (cdr stk))
(defun top (stk) (if (consp stk) (car stk) 0))
(defun push (val stk) (cons val stk))

; Single step for machine
(defun step (ins alist stk)
  (let ((op (car ins)))
    (case op
          (pushv (push (lookup (cadr ins) alist) stk)) ; Push var
          (pushc (push (cadr ins) stk))                ; Push const
          (dup   (push (top stk) stk))                 ; Duplicate top
          (add   (push (+ (top (pop stk)) (top stk))   ; Add top two and push back
                       (pop (pop stk))))
          (mul   (push (* (top (pop stk)) (top stk))   ; Mul top two and push back
                       (pop (pop stk))))
          (t stk))))                                   ; NOP, return stk


; Run a program
(defun run (program alist stk)
  (cond ((endp program) stk) 
        ((run (cdr program)
              alist
              (step (car program) alist stk)))))


; Compiler
