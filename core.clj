(ns concurrentexp.core
  (:gen-class))

(defn -main [& args]
  (let [channelagent (agent [])]
    (send channelagent conj (* 2 10))
    (send channelagent conj (* 2 20))
    (send channelagent conj (+ 30 40))
    (send channelagent
          (fn [[a b c]]
            (println a " + " b " + " c " = "
                     (+ a b c))))))