#lang racket

; Funciones generadoras: mostly a curiosity... pero podria ser util... 

; generadora -> lambda times . (lambda v . lambda v*times )
(define generadora
    (lambda (times) (lambda (v) (* v times) ) )
)

; Es esto valido?
(define por2 (generadora 2) )  ; Invocamos una funcion que crea a otra
(por2 25)                      

; Una lista de funciones, cada una con diferente times
(define funnyList
    (map (lambda (x) (generadora x) )  '(1 2 3 4 5 6 7 8 9 10) ))

; Usando map podemos aplicar cada funcion de la lista
(define tabla
    (lambda (x) (map (lambda (gen) (gen x)) funnyList))
)

(tabla 2) ; 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
(newline)

;----------------------------------------------------------------------------
; Problemas con listas: resuelve con map, apply y filter
; Sin recorrer listas manualmente

;  Lo relevante en estos ejercicios es el metodo, no el resultado
;  Consejo: busca problemas dentro de problemas, y resuleve lo mas facil primero 

;-----------------------------------------------------------------------------
; Frutas
; Este es el precio por kilo de varias frutas
(define  frutas   '( ( "manzana" "50" )
                        ( "pera" "70"  )
                        ( "limon" "40"  )
                        ( "fresa" "80"  )
                        ( "cereza" "55"  )
                      )
)

; Lola compro:
;      2 lbs de manzana
;      3 lbs limones
;      2.5  lbs  de fresas
;      0.5 lbs de cerezas

; Cuanto pago?

; hints: maps, filters, reglas de 3...

(define compra '( ( "manzana" 2 )
                ( "limon" 3 )
                ( "fresa" 2.5 )
                ( "cereza" 0.5 )
              )
)

(define (getPrice fruta)
    (define articulo (filter (lambda (x) (equal? (car x) fruta)) frutas))

    (if (empty? articulo)
        0
        (string->number (cadar articulo))
    )
)

(define (getKilos lbs)
    (* lbs 2.205)
)

(define (getTotal articulos)
    (apply + (map (lambda (x) (* (getPrice (car x)) (getKilos (cadr x)))) articulos))
)

(displayln "Total compra")
(getTotal compra)
(newline)
;------------------------------------------------------------------------------

; Wheather
; Estas son las temperaturas en Farenheit de una semana
(define semana  '( ("lunes" 78.5)
                   ("martes" 76.5)
                   ("miercoles" 80.5)
                   ("jueves" 85)
                   ("viernes" 87.5)
                   ("sabado" 86)
                   ("domingo" 90.5)
                 )

)
; En Celcius: 
; Cual es el dia mas frio
; Cual es el dia mas frio
; Cual es la temp promedio

(define (getCelcius temp)
    (/ (- temp 32) 1.8)
)

(define (getColdest temps)
    (apply min (map (lambda (x) (getCelcius (cadr x))) temps))
)

(define (getHotest temps)
    (apply max (map (lambda (x) (getCelcius (cadr x))) temps))
)

(define (getAvg temps)
    (/ (apply + (map (lambda (x) (getCelcius (cadr x))) temps)) 
        (length temps)) 
)

(define (getDay temps temp)
    (car (filter (lambda (x) (equal? (getCelcius (cadr x)) temp)) temps))
)

(displayln "Temperaturas")
(display "Mas frio: ")
(displayln (getDay semana (getColdest semana)))
(display "Mas caliente: ")
(displayln (getDay semana (getHotest semana)))
(display "Promedio: ")
(displayln (getAvg semana))
(newline)

;-------------------------------------------------------------------------------------


; manera ultra lazy y funcional 
(define (nodos grafo)
   (remove-duplicates (append (map car grafo) (map cadr grafo)))
)


( define (vecinos nodo grafo)
    (map (lambda (x) 
            (if (equal? (car x) nodo) (cadr x) (car x))
        )

        (filter (lambda (x) (member nodo x)) grafo)
    ) 
)

(define grafo '((1 2) (1 5) (2 5) (2 3) (3 4) (4 5) (4 6) ) )


(displayln "nodos del grafo")
(nodos grafo)
(newline)

(displayln "vecinos de un nodo (5)")
(vecinos 5 grafo)
(newline)


; DFS------------------------------------------------------------------
;   Nodo inicial entra a la stack
;   Hasta que la stack quede vacia o visites todos los nodos
;        Nodo sale de stack, y entran todos sus vecinos no visitados
;        Nodo que salio de stack se agrega a visitados
;   Devuelve visitados

(displayln "dfs")
(define (dfs G stack visited)
    (cond
        [(empty? stack) visited]
        [(equal? (length visited) (length (nodos G))) visited]
        [else 
            (dfs G
                (append (filter (lambda (x) (not (member x visited))) 
                        (vecinos (car stack) G)) 
                (cdr stack))
                (if (not (member (car stack) visited))
                    (append visited (list (car stack)))
                    visited
                )
            )
        ]
    )
)

(dfs  grafo '(1)  '()  )  ; pista de invocacion... stack y visited son parametros
(newline)

;-----------------------------------------------------------------------------
; Usa el mismo approach que el DFS para crear un BFS
; BFS es igual a DFS, pero con una cola
; BFS------------------------------------------------------------------
;   Nodo inicial entra a la cola
;   Hasta que la cola quede vacía o visites todos los nodos
;        Nodo sale de la cola, y entran todos sus vecinos no visitados al final de la cola
;        Nodo que salió de la cola se agrega a visitados
;   Devuelve visitados

(define (bfs G queue visited)
    (cond
        [(empty? queue) visited]
        [(equal? (length visited) (length (nodos G))) visited]
        [else
            (bfs G
                (append (cdr queue)
                    (filter (lambda (x) (not (member x visited)))
                        (vecinos (car queue) G)))
                
                (if (not (member (car queue) visited))
                    (append visited (list (car queue)))
                    visited
                )       
            )
        ]
    )
)

(displayln "bfs")
(bfs grafo '(1) '())
(newline)


;-----------------------------------------------------------------------------
; Ahora un quicksort
; 
(define (quicksort lst)
    (if (empty? lst)
        '()
        (append 
            (quicksort (filter (lambda (x) (< x (car lst))) (cdr lst)))
            (list (car lst))
            (quicksort (filter (lambda (x) (> x (car lst))) (cdr lst)))
        )
    )
)

(displayln "quicksort")
(quicksort '(3 2 1 4 5 6 7 8 9 10)) ; (1 2 3 4 5 6 7 8 9 10)
(newline)

;-----------------------------------------------------------------------------
; Dijkstra!
(define (Dijkstra G start end visited)
    (cond
        [(empty? G) '()]
        [(equal? start end) (append visited (list start))]
        [else
            (Dijkstra (filter (lambda (x) (not (member start x))) G) 
            (car (vecinos start G)) 
            end (append visited (list start)))
        ]
    )
)

(displayln "dijkstra")
(Dijkstra grafo 1 2 '())
(Dijkstra grafo 1 3 '())
(Dijkstra grafo 1 4 '())
(Dijkstra grafo 1 5 '())
(Dijkstra grafo 1 6 '())

; En todo lo anterior el resultado es trivial, se evalua el metodo:
; funcional, declarativo, simple, y 'lazy'. Sin declaraciones innecesarias. 
;-----------------------------------------------------------------------------

