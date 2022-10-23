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
              (eval (caddr exp) alist)))))))

; Stack machine
; Basic operation
(defun pop (stk) (cdr stk))
(defun top (stk) (if (consp stk) (car stk) 0))
(defun push (val stk) (cons val stk))

; Single step for machine
; @ins: the instruction
; @alist: a mapping list, var and its value
; @stk: machine stack
; return: stk
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
; @program: list of instructions
; @alist: var and its value, the input of a program
; @stk: machine stack
; return: stk
(defun run (program alist stk)
  (cond ((endp program) stk) 
        ((run (cdr program)
              alist
              (step (car program) alist stk)))))


; Compiler, from exp to program
(defun compile (exp)
  (cond
   ((atom exp) (cond ((symbolp exp)
                      (list (list 'pushv exp)))
                     (t (list (list 'pushc exp)))))
   ((equal (len exp) 2)
    (cond ((equal (car exp) 'inc)
           (append (compile (cadr exp)) '((pushc 1) (add))))
          (t (append (compile (cadr exp)) '((dup) (mul))))))
   (t (cond ((equal (cadr exp) '+)
             (append (compile (car exp))
                     (compile (caddr exp))
                     '((add))))
            (t (append (compile (car exp))
                       (compile (caddr exp))
                       '( (mul))))))))

; Proof helpers
(defthm composition
  (equal (run (append prg1 prg2) alist stk)
         (run prg2 alist (run prg1 alist stk))))


; Proof helper of general form
; Tell ACL2 how to induction a comile function
(defun compiler-induct (exp alist stk)
  (cond 
   ((atom exp) stk)
   ((equal (len exp) 2)
    (compiler-induct (cadr exp) alist stk))
   (t ; Any binary function may be used in place of append below
    (append (compiler-induct (car exp) alist stk)
            (compiler-induct (caddr exp)
                             alist
                             (cons (eval (car exp) alist)
                                   stk))))))

; Genernal form of compiler is correct
; Assert: The stack after running a program is equal the eval of exp append with original stack
; Explain: A program result is pushed into top of stack, and never changes elements below
(defthm compile-is-correct-general
  (implies (exprp exp)
           (equal (run (compile exp) alist stk)
                  (cons (eval exp alist) stk)))
  :hints (("Goal"
           :induct (compiler-induct exp alist stk))))

; Prove that compiler is correct
; Assert: The top of stack after running a program is equal the eval of exp
(defthm compile-is-correct
  (implies (exprp exp)
           (equal (top (run (compile exp) alist stk))
                  (eval exp alist))))#|ACL2s-ToDo-Line|#





   
   
   
   
   
   
   