#lang racket

(provide (all-defined-out))

(define (slow-add x y)
  (define (waste x)
    (if (= x 0)
      x
      (waste (- x 1))))
  (begin
    (waste 100000000)
    (+ x y)))


;TODO
(define (my-delay thunk)

;TODO
(define (my-force del)


;Test promise
(define my-promise (my-delay (lambda () (slow-add 3 4))))

;Test 1: Should take a while
(print (time (my-force my-promise)))

;Test 2: Should be instant
(print (time (my-force my-promise)))
