#lang racket

; Secuencia de fibo
(define (fibo n)
    (if (<= n 1) n
        (+ (fibo (- n 1)) (fibo (- n 2)))
    )
)

; Primeros x valores
(define (imprimeFibo x)
    (cond
        [(= x 0) (displayln (fibo x))]
        [else (imprimeFibo (- x 1)) (displayln (fibo x))]
    )
)

(imprimeFibo 8)