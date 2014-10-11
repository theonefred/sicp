(define-syntax delay
  (syntax-rules ()
    ((_ exp) (lambda () exp))))

(define-syntax cons-stream
  (syntax-rules ()
    ((_ a b) (cons a (delay b)))))

(define (force delayed)
  (delayed))

(define (memo-proc proc)
  (let ([already-run? #f]
        [result #f])
       (lambda ()
         (if already-run?
             result
             (begin
               (set! result (proc))
               (set! already-run? #t)
               result)))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-car s)
  (car s))

(define (stream-cdr s)
  (force (cdr s)))

(define (stream-map proc s)
  (cons-stream (proc (stream-car s))
               (stream-map proc (stream-cdr s))))

(define (stream-filter pred s)
  (if (pred (stream-car s))
      (cons-stream (stream-car s)
                   (stream-filter pred (stream-cdr s)))
      (stream-filter pred (stream-cdr s))))

(define (stream-map proc . streams)
  (cons-stream (apply proc (map stream-car streams))
               (apply stream-map (cons proc (map stream-cdr streams)))))

(define (print-stream s)
  (define (do-print s n)
    (if (= n 0)
        (newline)
        (begin
          (display (stream-car s))
          (display ", ")
          (do-print (stream-cdr s) (- n 1)))))
  (do-print s 20))

(define ones (cons-stream 1 ones))

(print-stream ones)

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers (cons-stream 1 (add-streams ones integers)))

(print-stream integers)

(define (fib a b)
  (cons-stream a (fib b (+ a b))))

(define fib-stream (fib 0 1))

(print-stream fib-stream)

