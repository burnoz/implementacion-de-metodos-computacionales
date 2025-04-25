#lang racket

; Sumatoria 0 - n
(define (0toN n)
    (if (= n 0) 0
        (+ n (0toN (- n 1)))
    )
)

(0toN 3)

; n veces "hola"
(define (hola n)
    (cond 
        [(= n 1) (display "hola")]
        [else (displayln "hola") (hola (- n 1))]
    )
)

(hola 2)

; Secuencia 1 - n
(define (sec1toN n)
    (cond
        [(> n 1) (sec1toN (- n 1))]
    )

    (display " ") (display n)
)

(newline)
(sec1toN 4)

; Secuencia n - 1
(define (secNto1 n)
    (display " ") (display n)
    
    (cond
        [(> n 1) (secNto1 (- n 1))]
    )
)

(newline)
(secNto1 4)
(newline)

; Factorial con tail recursion
(define (fact-tr n acumulador)
    (if (= n 0) acumulador
        (fact-tr (- n 1) (* acumulador n))
    )
)

(fact-tr 5 1)

; Fibo con tail recursion
(define (fibo-tr n a1 a2)
    (cond
    [(= n 0) a1]
    [(= n 1) a2]
    [else (fibo-tr (- n 1) a2 (+ a1 a2))]
    )
)

(fibo-tr 5 0 1)


(list 1 2 3 4)

(car '(1 2 3 4))
(cdr '(1 2 3 4)) 

; Acceder al segundo elemento
(car (cdr '(1 2 3 4)))
(cadr '(1 2 3 4))