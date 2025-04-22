#lang racket

; Parte 1
(displayln "Operaciones")
(+ 20 (/ 7 2))

(/ (+ 20 10) 2)

(+ (/ 20 2) 10)

(/ (expt 10 3) (* (+ 10 20) (* 10 2)))

(* (* (/ 1 2) 7) 4)

(* (expt 3 2) (expt 4 2))

(newline)

; Parte 2

; Fahrenheit a Celcius
(define (fahrenheit-to-celsius f)
    (/ (* 5 (- f 32)) 9)
)

; Pruebas
(displayln "Fahrenheit a Celcius")
(fahrenheit-to-celsius 212)
(fahrenheit-to-celsius 32)
(fahrenheit-to-celsius -40)
(newline)


; Sign
(define (sign n)
    (cond
        ((positive? n) 1)
        ((negative? n) -1)
        ((equal? n 0) 0)
    )
)

; Pruebas
(displayln "Sign")
(sign -5)
(sign 10)
(sign 0)
(newline)

; Raices de ecuacion
(define (roots a b c)
    (/ (+ (- b) (sqrt (- (expt b 2) (* 4 (* a c))))) (* 2 a))
)

; Pruebas
(displayln "Roots")
(roots 2 4 2)
(roots 1 0 0)
(roots 4 5 1)
(newline)

; Numero al cuadrado
(define (square n)
    (* n n)
)

; Pruebas
(displayln "Numero al cuadrado")
(square 2)
(square 1)
(square 4)
(newline)

; Mitad de un numero
(define (mitad n)
    (/ n 2)
)

; Pruebas
(displayln "Mitad de un numero")
(mitad 2)
(mitad 10)
(mitad 5)
(newline)

; n^2 + n/2
(define (expresion n)
    (+ (expt n 2) (/ n 2))
)

; Pruebas
(displayln "n^2 + n/2")
(expresion 2)
(expresion 1)
(expresion 3)
(newline)

; Distancia entre dos puntos
(define (distancia a b c d)
    (sqrt (+ (expt (- a c) 2) (expt (- b d) 2)))
)

; Pruebas
(displayln "Distancia entre dos puntos")
(distancia 1 1 1 1)
(distancia 1 4 1 2)
(distancia 1 2 3 4)
(newline)

; Potencia n a la x (recursiva)
(define (potencia n x)
    (if (= x 0) 1
        (* n (potencia n (- x 1)))
    )
)

; Pruebas
(displayln "Potencia n a la x")
(potencia 2 2)
(potencia 3 4)
(potencia 10 3)
