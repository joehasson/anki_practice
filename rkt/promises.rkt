#lang racket

(provide (all-defined-out))

(define (slow-add x y)
  (define (waste x)
    (if (= x 0)
      x
      (waste (- x 1))))
  (begin
    (waste 1000000000)
    (+ x y)))


;TODO
(define (my-delay thunk)
  (mcons #f thunk))

;TODO
(define (my-force del)
    (if (mcar del)
      (mcdr del)
      (begin
        (set-mcar! del #t)
        (set-mcdr! del ((mcdr del)))
        (mcdr del))))


;Test promise
(define my-promise (my-delay (lambda () (slow-add 3 4))))

;Test 1: Should take a while
(print (time (my-force my-promise)))

;Test 2: Should be instant
(print (time (my-force my-promise)))
