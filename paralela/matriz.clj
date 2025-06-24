(defn dot [a b]
    (apply + (map * a b))
)

(def traspuesta
    (fn [x] (apply map list x))
    ;; Lo mismo que lo de arriba pero abreviado
    ;; #(apply map list %)
)

(defn mxm [A B]
    (let [B-t (traspuesta B)]
        (map (fn [a] (map (fn [b] (dot a b)) B-t)) A)
    )
)


(def A '((1 2 3) (4 5 6) (7 8 9)))

(def B A)

(println (mxm A B))

;; (println
;; (map (fn [a] (map (fn [b] (dot a b)) B)) A))


;; Version paralela
(defn mxm-paralelo [A B]
    (let [B-t (traspuesta B)]
        (pmap (fn [a] (pmap (fn [b] (dot a b)) B-t)) A)
    )
)

