#lang racket

(provide (all-defined-out))

(define (stream-maker f)
  (letrec
    [(nexts (lambda (n) (cons (f n)
                              (lambda () (nexts (+ n 1))))))]
    (lambda () (nexts 1))))

