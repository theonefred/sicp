#!/usr/bin/env petite

;; using procedure to represent pair

(define (cons x y)
  (lambda (f) (f x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))

;; test

(define x (cons "A" "B"))
(display "(cons A B) ==> x = ")
(display x)
(newline)

(display "(car x) ==> ")
(display (car x))
(newline)

(display "(cdr x) ==> ")
(display (cdr x))
(newline)

(exit)
