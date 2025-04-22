#lang racket

; Comentario

; Se puede usar quote o ' para imprimir en la consola
'(+ 20 (/ 7 2))
(quote (+ 20 (/ 7 2)))

(+ 20 (/ 7 2))

; Salto de linea
(newline)

(/ (+ 20 10) 2)

(+ (/ 20 2) 10)

(/ (expt 10 3) (* (+ 10 20) (* 10 2)))

(* (* (/ 1 2) 7) 4)

(* (expt 3 2) (expt 4 2))

; Binding
(define b 5)
(display b)

; Funcion
(define (mas10 x)
    (+ x 10)
)

(newline)

(mas10 b)

(define (factorial n)
    (if (= n 0) 1
        (* n (factorial (- n 1)))
    )
)

(factorial 5)