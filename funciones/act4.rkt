#lang racket

; Numero mayor de una lista imbricada
(define (mayorImbricada L)
    (cond 
        [(empty? L) 0]
        [(pair? (car L)) (if (> (mayorImbricada (car L)) (mayorImbricada (cdr L)))
                (mayorImbricada (car L))
                (mayorImbricada (cdr L))
        )]
        [else (if (> (car L) (mayorImbricada (cdr L)))
                (car L)
                (mayorImbricada (cdr L))
        )]
    )
)

(display "Numero mayor de una lista imbricada")
(newline)
(mayorImbricada '(1 2 (3 4) (5 10)))
(mayorImbricada '(2 3 (4 5) (6 15 8) (9 10)))
(newline)

(define grupo '(("A01" "Ana" (10 10 8))
                ("A02" "Carlos" (10 8 9))
                ("A03" "Luisa" (9 10 10))
                ("A04" "Juan" (8 8 8))
                ("A05" "Juan" (9 7 8)))
)

; Obtener el nombre de un alumno
(define (getNombre L)
    (car (cdr L))
)


; Verifica si un id esta en el grupo
(define (buscaID L id)
    (cond
        [(empty? (filter (lambda (x) (equal? (car x) id)) L)) #f]
        [else #t]
    )
)

; Obtener las calificaciones
(define (calificaciones L)
    (car (cdr (cdr L)))
)

; Promedio de calificaciones
(define (promedio L)
    (/ (apply + (calificaciones L)) (length (calificaciones L)))
)

; Datos por matricula
(define (datos L id)
    (filter (lambda (x) (equal? (car x) id)) L)
)

(display "Extraer los nombres")
(newline)
(map (lambda (x) (getNombre x)) grupo)
(newline)

(display "Busca por matricula")
(newline)
(buscaID grupo "A01")
(buscaID grupo "A015") ; No existe
(newline)

(display "Promedios")
(newline)
(map (lambda (x) (promedio x)) grupo)
(newline)

(display "Datos por matricula")
(newline)
(datos grupo "A01")
(datos grupo "A04")
(datos grupo "A015") ; No existe
(newline)