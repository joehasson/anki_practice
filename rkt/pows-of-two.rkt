#lang racket
(provide (all-defined-out))

(define pows-of-two
  (letrec 
	 [(next (lambda (x) (cons
						 x
						 (lambda () (next (* x 2))))))
	 ]
   (lambda () (next 1))))
	
