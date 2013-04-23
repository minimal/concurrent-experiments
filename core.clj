(ns concurrentexp.core
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  ;; work around dangerous default behaviour in Clojure
  (alter-var-root #'*read-eval* (constantly false))
  (let [channelagent (agent [])]
    ;; with a single agent
    (send channelagent conj (* 2 10))
    (send channelagent conj (* 2 20))
    (send channelagent conj (+ 30 40))
    (send channelagent
          (fn [[a b c]]
            (println a " + " b " + " c " = "
                     (+ a b c))))))