;;; Exercise 6.3
; Solution from github
(include-book "ordinals/e0-ordinal" :dir :system)
(set-well-founded-relation e0-ord-<)

(defthm w-larger-than-nats
  (implies (natp x)
       (e0-ord-< x '(1 . 0))))

(defthm w-smaller-than-non-nats
  (implies (and (e0-ordinalp x)
        (not (natp x))
        (not (equal x '(1 . 0))))
       (e0-ord-< '(1 . 0) x)))#|ACL2s-ToDo-Line|#




;;; Exercise 6.4
(e0-ordinalp '(2 1 . 27))
; T, w^2+w+27

(e0-ordinalp '(2 1 1 . 27))
; T, w^2+(w*2)+27

(e0-ordinalp '(2 1 0 . 27))
; NIL

(e0-ordinalp '(1 2 2 . 27))
; NIL
