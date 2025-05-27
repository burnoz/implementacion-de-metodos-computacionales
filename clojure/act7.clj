;; Ordenar valores
(defn ordenar [lista]
    (if (empty? lista)
        '()    
        (concat 
                (ordenar (filter (fn [x] (< x (first lista)))(rest lista)))
                (list (first lista))
                (ordenar (filter (fn [x] (> x (first lista)))(rest lista)))
        )
    )
)

(println "Ordenar lista")
(println (ordenar '(3 2 1 4 5)))


;; Concatenar listas sin append
(defn concat-listas [lista1 lista2]
    (if (empty? lista1)
        lista2
        (concat (list (first lista1)) (concat-listas (rest lista1) lista2))
    )
)

(println "\nConcatenar listas")
(println (concat-listas '(1 2 3) '(4 5 6)))

;; Función que produce la tabla de multiplicar de un número dado mediante funciones generadoras
;; (defn generadora
;;     (fn [v] (fn [times] (* v times)) )
;; )

(defn generadora [times]
    (fn [v] (* v times))
)

(println "\nTablas")
(println (map (fn [x] ((generadora x) 2)) '(1 2 3 4 5 6 7 8 9 10)))
(println (map (fn [x] ((generadora x) 3)) '(1 2 3 4 5 6 7 8 9 10)))


;; Fibonacci.   
(defn fibo [a b n]
    (if (= n 0)
        '()
        (cons a (fibo b (+ a b) (dec n)))
    )
)

(println "\nFibonacci")
(println (fibo 0 1 10))


;; Conversiones

(def ingredientes  ' (  ("1/2" "taza" "azucar")   ("1" "taza"  "harina" )   ( "3/4" "taza" "mantequilla"  )   ))

;; Ratios
;; Azucar -> taza: 250 gramos
;; Harina -> taza: 250 gramos
;; Mantequilla -> taza: 225 gramos

(def ratios '((250 "azucar")
              (250 "harina")
              (225 "mantequilla")))

(defn getRatio [element]
    (first (filter 
        (fn [x] (= element (last x))) ratios))
)

(defn convertir [ingrediente]
    (concat (list (last ingrediente)) (list (* (float (read-string (first ingrediente))) (first (getRatio (last ingrediente))))))
)

(println "\nConversiones tazas -> gramos")
(println (map convertir ingredientes))