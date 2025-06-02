(def f1 (future (println "boing!") (+ 10 30)))

;; (println f1)

(println (deref f1))


(def f2 (future (println "zoom!") (Thread/sleep 3000) (+ 10 30)))

;; status->pending, val: nil
(println f2)

;; Accede al valor hasta que esta listo
(println (deref f2))

;; No se ejecuta hasta que el resultado sea requerido
(def unDelay (delay (println "me saturn!") (Thread/sleep 3000) (+ 10 30)))

(println unDelay)

(force unDelay)
(println unDelay)


;; No se ejecuta ni se define hasta un deliver
(def pizza (promise))

(deliver pizza "not pizza, just boing!")

(realized? pizza)
(println @pizza)
(realized? pizza)