#lang racket

; Contar elementos de una lista
(define (contarElementos L acum)
    (if (empty? L) 
        acum
        (contarElementos (cdr L) (+ acum 1))
    )
)

; Sumar elementos de una lista
(define (sumarElementos L acum)
    (if (empty? L) 
        acum
        (sumarElementos (cdr L) (+ acum (car L)))
    )
)

; Promedio de una lista
(define (promedio lista)
    (if (empty? lista)
        ; El promedio es 0 si la lista esta vacia
        0
        ; Suma de elementos / numero de elementos
        (/ (sumarElementos lista 0) (contarElementos lista 0))
    )
)

(display "Promedio de la lista: ")
(newline)
(promedio '(1 2 3 4 5 6 7 8 9))
(promedio '(1 2 3 4 5 6 7 8 9 10))
(promedio '(2 2 2 2 2 2))
(newline)


; Numero mayor de una lista
(define (mayor L)
    (if (empty? L)
        ; Si la lista esta vacia, devuelve 0
        0
        ; Si no esta vacia, compara el primer elemento con el mayor del resto de la lista
        (if (> (car L) (mayor (cdr L)))
                ; Devuelve el primer elemento si es mayor
                (car L)
                ; Si no, devuelve el mayor del resto de la lista
                (mayor (cdr L))
        )
    )
)

(display "Numero mayor de una lista")
(newline)
(mayor '(2 3 4 5 6 7 8 9 10))
(mayor '(7 2 5 6 8 10 20 9))
(newline)


; Verificar si una lista contiene un elemento
(define (contiene L e)
    ; Si llega al final de la lista o esta vacia, devuelve #f
    (if (empty? L) 
        "#f"
        ; Compara el primer elemento con el elemento buscado
        (if (= (car L) e) 
            ; Si son iguales, devuelve #t
            "#t"
            ; Si no son iguales, verifica el resto de la lista
            (contiene (cdr L) e)
        )
    )
)

(display "Averigua si la lista contiene un elemento")
(newline)
(contiene '(1 2 3 4 5) 3)
(contiene '(1 2 3 4 5) 10)
(newline)


; Ocurrencias de un elemento en una lista
(define (ocurrencias L acum)
    ; Si la lista esta vacia, devuelve 0
    (if (empty? L) 
        0
        ; Compara el primer elemento con el elemento buscado
        (if (= (car L) acum)
            ; Si son iguales, suma 1 a las ocurrencias del resto de la lista
            (+ 1 (ocurrencias (cdr L) acum))
            ; Si no son iguales, verifica el resto de la lista
            (ocurrencias (cdr L) acum)
        )
    )
)

(display "Cuenta el numero de ocurrencias de un elemento en la lista")
(newline)
(ocurrencias '(1 2 3 4 5 1 2 3 4 5) 3)
(ocurrencias '(1 2 3 4 5 1 2 3 4 5) 10)
(newline)


; n veces 0
(define (nveces0 n)
    (if (= n 0)
        ; Si ya se agregaron n ceros, devuelve null
        null
        ; Si no, agrega un 0 a la lista y llama a la funcion con n-1
        (cons 0 (nveces0 (- n 1)))
    )
)

(display "Lista de n veces 0")
(newline)
(nveces0 5)
(nveces0 2)
(newline)


; 1 a n
(define (unoAN n)
    ; Funcion auxiliar para generar la lista
    (define (aux i n)
        (if (> i n)
            ; Si ya se llego a n, devuelve null
            null
            ; Si no, agrega el valor de i a la lista y llama a la funcion con i+1
            (cons i (aux (+ i 1) n))
        )
    )
    
    ; Llama a la funcion auxiliar desde 1 hasta n
    (aux 1 n)
)

(display "Lista de 1 a n")
(newline)
(unoAN 5)
(unoAN 7)
(newline)


; n a 1
(define (nAuno n)
    (if (= n 0)
        ; Si ya se llego a 0, devuelve null
        null
        ; Si no, agrega el valor de n a la lista y llama a la funcion con n-1
        (cons n (nAuno (- n 1)))
    )
)

(display "Lista de n a 1")
(newline)
(nAuno 5)
(nAuno 7)
(newline)


; Lista de n valores de Fibonacci
(define (fibonacci n)
    ; Funcion auxiliar para generar la lista de Fibonacci
    (define (aux a b n)
        (if (= n 0)
            ; Si ya se generaron n valores, devuelve null
            null
            ; Si no, agrega el valor de a a la lista y llama a la funcion con b, a+b y n-1
            (cons a (aux b (+ a b) (- n 1)))
        )
    )

    ; Llama a la funcion auxiliar con los primeros dos valores de Fibonacci hasta el n valor
    (aux 0 1 n)
)

(display "Lista con elementos de fibonacci")
(newline)
(fibonacci 5)
(fibonacci 7)
(newline)


; Lista de numeros pares en un rango
(define (pares a b)
    (if (> a b)
        ; Si se llego al final del rango, devuelve null
        null
        (if (even? a)
            ; Si el numero es par, agrega a la lista y llama a la funcion con a+1
            (cons a (pares (+ a 1) b)) 
            ; Si no es par, llama a la funcion con a+1 sin agregar a la lista
            (pares (+ a 1) b)
        )
    )
)

(display "Lista de numeros pares en un rango")
(newline)
(pares 1 8)
(pares 3 12)
(newline)


; Sumar listas de misma longitud
(define (sumarListas L1 L2)
    (if (or (empty? L1) (empty? L2))
        ; Si alguna de las listas esta vacia, devuelve null
        null
        ; Si no, suma el primer elemento de cada lista y llama a la funcion con el resto de las listas
        (cons (+ (car L1) (car L2)) (sumarListas (cdr L1) (cdr L2)))
    )
)

(display "Sumar listas de la misma longitud")
(newline)
(sumarListas '(1 2 3) '(4 5 6))
(sumarListas '(2 9 5) '(2 3 4))
(newline)


; Concatenar listas sin append
(define (concatenar L1 L2)
    (if (empty? L1)
        ; Si ya se agregaron todos los elementos de la primera lista, devuelve la segunda lista
        L2
        ; Si no, agrega el primer elemento de la primera lista a la lista resultante 
        ; Llama a la funcion con el resto de la primera lista y la segunda lista
        (cons (car L1) (concatenar (cdr L1) L2))
    )
)

(display "Concatenar listas")
(newline)
(concatenar '(1 2 3) '(4 5 6))
(concatenar '(2 9 5) '(2 3 4))
(newline)


; Invertir una lista
(define (invertir L aux)
    (if (empty? L)
        ; Si la lista esta vacia, devuelve la lista auxiliar
        aux
        ; Si no, llama a la funcion con el resto de la lista
        ; Y agrega el ultimo elemento de la lista original al inicio de la lista auxiliar
        (invertir (cdr L) (cons (car L) aux))
    )
)

(display "Invertir una lista")
(newline)
(invertir '(1 2 3 4 5) null)
(invertir '(5 4 3 2 4 1) null)
(newline)



; Insertar un valor ordenado en una lista
(define (insertar L valor)
    (if (empty? L)
        ; Si la lista esta vacia, devuelve una lista con el valor
        (list valor)
        (if (< valor (car L))
            ; Si el valor es menor que el primer elemento de la lista, agrega el valor al inicio
            (cons valor L)
            ; Si no, agrega el primer elemento de la lista y llama a la funcion con el resto de la lista
            (cons (car L) (insertar (cdr L) valor))
        )
    )
)

(display "Insertar un valor en orden")
(newline)
(insertar '(3 7 9) 4)
(insertar '(3 7 9) 8)
(newline)


; Ordenar una lista
(define (ordenar L)
    (if (empty? L)
        ; Si la lista esta vacia, devuelve null
        null
        ; Si la lista no esta vacia, llama a la funcion insertar con el resto de la lista y el primer elemento
        (insertar (ordenar (cdr L)) (car L))
    )
)

(display "Ordenar una lista")
(newline)
(ordenar '(20 5 0 10 15 25))
(ordenar '(3 7 9 1 2 4 5 6))
(newline)


; Sumar listas de diferente longitud
(define (sumarListas2 L1 L2)
    (if (empty? L1)
        ; Si la primera lista esta vacia, devuelve la segunda lista
        L2
        (if (empty? L2)
            ; Si la segunda lista esta vacia, devuelve la primera lista
            L1
            ; Si ambas listas tienen elementos, suma el primer elemento de cada lista
            (cons (+ (car L1) (car L2)) (sumarListas2 (cdr L1) (cdr L2)))
        )
    )
)

(display "Sumar listas de diferente longitud")
(newline)
(sumarListas2 '(1 2 3) '(4 5 6 7 8))
(sumarListas2 '(2 9 5) '(2 3 4 5 9))
(newline)