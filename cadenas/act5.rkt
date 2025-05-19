#lang racket


; Problemas con cadenas----------------------------------------

; hola abarca del indice 0 al 4
(define cadena "hola bye" )


; Como extraer el substring "hola"?
; funcion   (substring  str  start end)
(displayln "\n extraer hola")
(substring cadena 0 4)

; Como eliminar "hola" de cadena?
; also funcion   (substring  str  start)
(displayln "\n string sin hola")
; Extrae hasta el final de la cadena
(substring cadena 5)


; Crea una funcion que extrae substrings dados indices}
; Recibe una cadena y una lista impropia
; Devuelve la subcadena en los indices definidos por la lista
(define  (subca str vals)
    (substring str (car vals) (cdr vals))
)
(define x '(0 . 4) )
(displayln "\n Funcion que extrae substrings dados indices")
(subca "hola bye" x) 

; (car '(0 . 4)) -> 0
; (cdr '(0 . 4)) -> 4

; Concatena cadenas
(displayln "\n Concatenaciones")
(string-append "Apple" "Banana" "Coco")


; Longuitud de una cadena
(displayln "\n String length")
(string-length "Apple")


; -------------------------------------------------------------
; Resuelve los siguientes ejercicios con map, apply, filter
; y funciones lambda 
; Produce codigo limpio y breve


; -------------------------------------------------------------
; Cafe
; Dada la lista... 
(define cafes      '( ( "Americano" 55 )
                      ( "Expresso"  50 )               
                      ( "Ice Frapuccino" 72)
                      ( "Latte"     70 )
                      ( "Capuccino" 71)
                    )
 )
; Cual es el cafe mas caro ? 
; Salida esperada:  ( "Ice Frapuccino" 72)
; hints:  apply, max, filter
(define (masCaro L)
    (apply max (map cadr L))
)

(define (getcafe L value)
    ; Devuelve en forma de lista, util en caso de elementos con el mismo valor
    ; (filter (lambda (x) (equal? value (cadr x))) L)

    ; Primer elemento de la lista generada por filter, util en caso de valores unicos
    (car (filter (lambda (x) (equal? value (cadr x))) L))
)


(displayln "\n el cafe mas caro")
(getcafe cafes (masCaro cafes))

  
;--------------------------------------------------------------
; ... con pan
; Limpia la lista:
;    tiene 0's innecesarios, que estan en una lista impropia
;    tiene un #f al final

; salida esperada: una lista con forma similar a la lista de cafes, sin los #f
; hints: filter, map, lambda, car y cdr 
(define panes      '( ( "dona"    (0 . 40) )
                      ( "muffin"  (0 . 35) )               
                      ( "cupcake" (0 . 30) )
                      ( "manteconcha"  (0 . 42) )
                      ( "galleta" (0 . 25))
                      ( "#f" )
                      ( "lemon bar" (0 . 35) )
                   )
)

(define limpiarF
    (lambda (x) (not (equal? "#f" (car x))))
)

(define panPrice
    (lambda (x) (list (car x) (cdadr x)))
)

; (filter limpiarF panes)
(displayln "\n panes")
(map panPrice (filter limpiarF panes))



;---------------------------------------------------------------
; Saludos
; Crea una funcion que concatena un hola con su respectivo adios  

; Salidas esperadas: 
;(sayhi "hola") > devuelve "hola -> adios"
;(sayhi "hi") >   devuelve "hi -> bye" 
;(sayhi "ciao") >   devuelve "ciao -> arrivederci" 
; hints: concatenacion, comparaciones 
(define (sayhi str)
    (cond
        [(equal? str "hola") (string-append str " -> adios")]
        [(equal? str "hi") (string-append str " -> bye")]
        [(equal? str "ciao") (string-append str " -> arrivederci")]
        [(equal? str "bonjour") (string-append str " -> au revoir")]
        ; [else (string-append str " -> ?")]
    )
)

(define saludo (list  "hi"  "hola" "bonjour" "ciao"   ) )

(displayln "\n Saludos")
(map sayhi saludo)

; ------------------------------------------------------------------
; Grafos!
; Este es un grafo simple y no dirigido
; Cada par es una arista

; hints: map, filter, lambda, lenght

(define grafo '((1 2) (1 5) (2 5) (2 3) (3 4) (4 5) (4 6) ) )

; Lista los nodos del grafo
; salida esperada: (1 2 5 3 4 6)

(displayln "\n nodos del grafo")

(define (nodos grafo)
    (append (map car grafo) (map cadr grafo))
)

(define (sin-repetidos lst)
    (if (empty? lst)
        '()
        (cons (car lst) (sin-repetidos (filter (lambda (x) (not (equal? (car lst) x))) (cdr lst))))
    )
)

(displayln (sin-repetidos (nodos grafo)))

; lista las aristas de un nodo dado
; Ej. aistas de 5 -> '( (1 5) (2 5) (4 5) )
(define (aristas grafo nodo)
    (filter (lambda (x) (or (equal? nodo (car x)) (equal? nodo (cadr x)))) grafo)
)

(displayln "\n aristas de un nodo (5)")
(displayln (aristas grafo 5))

; Grado de cada nodo. ie. cuantos vecinos tiene
(define (grado grafo nodo)
    (length (aristas grafo nodo))
)

(define (grados grafo)
    ; (nodo . grado)
    (map (lambda (x) (cons x (grado grafo x))) (sin-repetidos (nodos grafo)))
)

(displayln "\n grado de cada nodo")
(displayln (grados grafo))


; Adyacencia: dados dos nodos, son vecinos o no??  
(define (adyacente grafo nodo1 nodo2)
    (or (equal? nodo1 nodo2) 
        (not (empty? (filter (lambda (x) (or (equal? nodo1 (car x)) (equal? nodo1 (cadr x)))) (aristas grafo nodo2))))
    )
)

(displayln "\n adyacente (1 5)")
(displayln (adyacente grafo 1 5))
(displayln "\n adyacente (4 3)")
(displayln (adyacente grafo 4 3))
(displayln "\n adyacente (1 6)")
(displayln (adyacente grafo 1 6))
  
;-------------------------------------------------------------------
; Imagina que tienes una lista de tokens
; Cada sublista es un label de token, y su cadena
; Concatena cada cadena con el html correcto dado el tipo de token 
(define tokens  '(  ("kw-state" "states")
                  ("colon" ":")
                  ("state-ID" "S1")
                  ("coma"  ",")
                  ("state-ID"  "S2")
                  ("coma" ",")
                  ("state-ID"  "S2")
                ) )

; Salida esperada 
;       "<text class='keywords'> states </text> 
;	<text class='colon'>:</text> 

;	<text class='stateID'>S1</text>
;	<text class='coma'>,</text>

;	<text class='stateID'>S2</text>
;	<text class='coma'>,</text>

;	<text class='stateID'>S3</text>
;	<text class='semicolon'>;</text> "

(define (htmlize tokens)
    (map (lambda (x) (string-append "<text class='" (car x) "'>" (cadr x) "</text>")) tokens)
)

(displayln "\n html")
(map displayln (htmlize tokens))


; Guarda el string resultante de la cadena anterior en un archivo...    
; Investiga como escribir en archivos....
(define (write-file filename content)
    (define out (open-output-file filename #:exists 'replace))
    (display content out)
    (close-output-port out)
)

(define (write-html filename tokens)
    (define html (htmlize tokens))
    (define content (apply string-append html))
    (write-file filename content)
)

(write-html "tokens.html" tokens)


;------------------------------------------------------------------

; Tres regex: una  para ints, otra para float, otra para 'states'
(define rg-int   (list "int"   #rx"^[0-9]+") )
(define rg-float (list "float" #rx"^[0-9]+\\.[0-9]+") )    
(define rg-state (list "state" #rx"s[0-9]+"  ) )
; Define una regex que reconozca una coma.... 
(define rg-coma  (list "coma"  #rx"," ) )


; Guarda las regex anteriores  en una lista
; (define rg-varias (list rg-int rg-float ... etc ) )
(define rg-varias (list rg-float rg-int rg-coma rg-state))

; Tokeniza esta linea
; hints: ejercicios anteriores, maps, filter, apply, funciones recursivas que crean listas...

; Nota que a veces no hay espacios...
; (no modifiques el input-str) 
(define input-str "0.1 5 s1,s2 " )

; Salida esperada:
; Una lista asi
; '( ( "0.1" "float" ) ( "int" "5" ) ( "state" "s1" ) ("coma" ",")  ("state" "s2") )

; Tokenizer
(define (tokenize input-str rg-varias)
    (map (lambda (x) (list (car x) (regexp-match (cadr x) input-str))) rg-varias)
)

(displayln "\n tokenizacion")
(tokenize input-str rg-varias)
