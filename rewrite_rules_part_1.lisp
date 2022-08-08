(implies (and (natp i)
              (< i (len a)))
         (equal (put i v (append a b))
                (append (put i v a) b)))

(put i v (append a b))

