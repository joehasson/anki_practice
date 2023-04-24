#lang racket

(provide (all-defined-out))

(define (stream-maker f) 
  (letrec [(nexts (lambda (n) (cons
                                (f n)
                                (lambda () (nexts (+ n 1))))))]
    (lambda () (nexts 1)))
  )

(define (get-next s)
  (begin
    (display (car (s)))
    (display "\n")
    (cdr (s))))

(define _ (stream-maker (lambda (n) (* n n))))
(display "Should print out 1, 4, 9, 16, 25,36...\n")
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))

(display "\n")

(set! _ (stream-maker (lambda (n) (* 3 n))))
(display "Should print out 3,6,9,12,15,18...\n")
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
(set! _ (get-next _))
