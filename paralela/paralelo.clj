;; Clojure paralelo

(defn slow-process [n]
    (Thread/sleep 3000)

    (+ n 10)
)

(def num-elementos 10)
(def lista (range num-elementos))
;; (def lista '(1 2 3 4 5 6))

;; Version secuencial
(time
    (doall (map slow-process lista))
)

;; Procesamiento paralelo con un chunk size automatico
(time
    (doall (pmap slow-process lista))
)

;; pmap con chunk size especifico
(def num-threads 4)
(def chunk-size (/ num-elementos num-threads))
(def datos-part (partition-all chunk-size lista))
;; (println (partition-all chunk-size lista))


(time
    (pmap (fn [x] (doall (map slow-process x))) datos-part)
)


(def resultado
    (pmap (fn [x] (doall (map slow-process x))) datos-part)
)


(println
    ;; Une los datos nuevamente
    (apply concat resultado)
)
;; (println resultado)


(def lista-cadenas '("cadena 1" 
                    "hola adios"
                    "boing"
                    "zoom")