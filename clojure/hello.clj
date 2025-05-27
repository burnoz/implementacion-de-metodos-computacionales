; Hello world
(println "Hello World!")

; Esto es un comentario
(print "es " (+ 8 8))
(println "es " (+ 8 8))

; Declaracion de funcion
; defn =(casi) define 
; defn pra funciones
(defn multi  [x y]  (* x y) )
(println (multi 5 10) )


(defn sum-of-numbers [x y]
	  (println (format "x + y = %d" (+ x y)))
)
(sum-of-numbers 1 25)




; Hello world
; def  para bindings 
(def cosas (list  1 2 5 7 9) ) 
(println cosas)

; fn = lambda
;Sintaxis: (def nombre (fn  [params]  body  ) )
(def hello (fn [] "Hello world"))
(println (hello) )

;-----------------------------------------------------
; fn, map y every
(println "\nMAP y EVERY CON FN")
(println (map (fn [x] (+ x 3) ) '(1 2 3 4)  ) )

(def numbers '(1 2 3 4))
(println (map (fn [x] (* x 2) ) numbers  ) )

(println "\nEvery")
(println (every? (fn [x] (= x 2) ) numbers  ) )
(println (every? (fn [x] (= x 2) ) '(2 2 2 2 )  ) )

; apply 
(println (apply + '(1 2 4 5)) )

(println (map inc '(1 2 4 5)) )

; same as car
(println (first '(1 2 4 5)) )
; same as cdr 
(println (rest '(1 2 4 5))  )

;---------------------------------------

(defn suma-if [n] 
	(	if (= n 0)   0
		   ( + n ( suma-if (dec n) ) )
	)
)

(println (suma-if 5) )
;--------------------------------------

(defn compara [ x y] 
	(if (= x y)
		(do 
			(println "Same")
			true
		)
		(do 
			(println "Not same")
			false
		)
	)
)

(println (compara 5 8 ) )

(def compara-2 (fn [x y] (= x y) ))

(println (compara-2 8 5) )

;-----------cond

(defn undos [x]
	(cond
		(= x 1) (do (println "un uno!") true )
		(= x 2) (do (println "un dos!") true )
		:else  (do (println "otra cosa") false ) 
	)

)
(println "\n\n ej cond")
(println (undos 7) )
(println (undos 2) )

