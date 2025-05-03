#lang racket
(require sdraw) 

(define (dibujaLista L)
  (sdraw L #:horizontal-spacing 100
         #:vertical-spacing 50
         #:null-style '/ #:null-thickness 0.5)
)

; Lista con list
(list 1 2 3 4)
'(1 2 3 4)

; Lista con cons
(cons 1 (cons 2 (cons 3 (cons 4 null)))) ; Lista propia y plana

; Listas anidadas/imbricadas
(cons (cons 1 (cons 2 null)) (cons 3 null))

(define b (cons (cons 1 (cons 2 null)) (cons 3 (cons 4 null))))

(dibujaLista b)
(dibujaLista '((1 2) (3 4)))

; Lista impropia
(cons 4 5)
(dibujaLista (cons 4 5))

; Obtener primer elemento de una lista
(car (list 1 2 3 4))

; Resto de la lista
(cdr (list 1 2 3 4))

; Obtener distintos elementos
(cadr (list 1 2 3 4))
(car (cdr (list 1 2 3 4))) ; Equivalentes
