#lang racket

(define lista '(1 2 (3 4) (5 (6 7))))

(displayln (car lista))
(displayln (cadr lista))
(displayln (caaddr lista))
(displayln (cadr (caddr lista)))
(displayln (car (cadddr lista)))
(displayln (caadr (cadddr lista)))
(displayln (cadr (cadr (cadddr lista))))
(newline)

(define lista2 '(a (b c d) e (f g)))

(displayln (car lista2))
(displayln (caadr lista2))
(displayln (cadr (cadr lista2)))
(displayln (caddr (cadr lista2)))
(displayln (caddr lista2))
(displayln (car (cadddr lista2)))
(displayln (cadr (cadddr lista2)))
(newline)

(define lista3 '(1 2 3 5 89))

(define (contarElementos L acum)   
  (if (empty? L) acum
      (contarElementos (cdr L) (+ acum 1))
  )
)

(contarElementos lista3 0)


(define (sumarElementos L acum)
  (if (empty? L) acum
      (sumarElementos (cdr L) (+ acum (car L)))
  )
)

(sumarElementos lista3 0)

(define Lista4 '(1  12  30  4  7))

(define (aumentarUno L)
    (if (empty? L) null
        (cons (+ 1 (car L)) (aumentarUno (cdr L)))
    )
)

(aumentarUno Lista4)