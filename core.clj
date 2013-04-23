(ns concurrentexp.core
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  ;; work around dangerous default behaviour in Clojure
  (alter-var-root #'*read-eval* (constantly false))
  (println "Hello, World!")
  (let [promise-a (promise)
        promise-b (promise)
        promise-c (promise)
        channelagent (agent [])
        mainagent (agent nil)]

    ;; with promises
    (send mainagent
          (fn [_]
            (println @promise-a " + " @promise-b " + " @promise-c " = "
                     (+ @promise-a @promise-b @promise-c))))
    (future (deliver promise-a (* 2 10)))
    (future (deliver promise-b (* 2 20)))
    (future (deliver promise-c (+ 30 40)))

    ;; with a single agent
    (send-off channelagent conj (* 2 10))
    (send channelagent conj (* 2 20))
    (send channelagent conj (+ 30 40))
    (send channelagent
          (fn [[a b c]]
            (println a " + " b " + " c " = "
                     (+ a b c))))

    ))
