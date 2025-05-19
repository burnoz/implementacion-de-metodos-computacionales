#lang racket

; Sumar valores en una lista anidada

(define (sumaL L)
    (cond 
        [(empty? L) 0]
        [(pair? (car L)) (+ (sumaL (car L)) (sumaL (cdr L)))]    
        [else (+ (car L) (sumaL (cdr L)))]    
    )
)


(define (cuentaL L)
    (cond 
        [(empty? L) 0]
        [(pair? (car L)) (+ (cuentaL (car L)) (cuentaL (cdr L)))]    
        [else (+ 1 (cuentaL (cdr L)))]    
    )
)


(define (aplana L)
    (cond
    [(null? L) null]
    [(pair? (car L)) (append (aplana (car L)) (aplana (cdr L)))]
    [else (append (list (car L)) (aplana (cdr L)))]
    )
)

(define (buscar L n)
    (cond 
        [(null? L) #f]
        [(pair? (car L)) (or (buscar (car L) n) (buscar (cdr L) n))]
        [(= n (car L)) #t]
        [else (buscar (cdr L) n)]
    )
)

(define L '(1 (2 4) 5))
(define L2 '(20 (2 3) 25 (2 3 4)))

(sumaL L)
(sumaL L2)
(cuentaL L)
(cuentaL L2)
(aplana L)
(aplana L2)
(buscar L 4)
(buscar L2 6)

(define (compara x y)
    (= x y)
)

; Filter, devuelve elementos que cumplan con un criterio
(filter positive? '(1 2 -5 -8 -40 1 0 100))
(filter (lambda (x) (compara x 3)) '(1 2 -5 -8 -40 3 0 100))

; Apply, aplica una funcion sobre una lista
(apply + '(1 2 3 4))

; Map, aplica una funcion a los elementos de una lista
(define (funcion x)
    (+ x 1)
)

(map funcion '(1 2 3 4))

(map (lambda (x) (* x 2)) '(1 2 3 4))
(map (lambda (x) (reverse x)) '((3 mar) (5 feb) (11 may)))
